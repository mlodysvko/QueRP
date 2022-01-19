var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var prefix = Deck.prefix
var transform = prefix('transform')
var translate = Deck.translate
var $container = document.getElementById('container')
var $topbar = document.getElementById('topbar')

var $hit = document.createElement('button')
var $stay = document.createElement('button')
var $score = document.createElement('button')

var canEscape = false;
var requestedActions = 0;
var finishedActions = 0;

var coins = 0;
var obecnyBet = 100;

function canAct() {
	return (finishedActions >= requestedActions)
}

function queActions(num) {
	requestedActions = num;
	finishedActions = 0;
}

function plusminus(value) {
	var plusminus = Math.round(Math.random()) ? -1 : 1;

	return plusminus * value;
}

function fisherYates(array) {
var rnd, temp;

	for (var i = array.length - 1; i; i--) {
	  rnd = Math.random() * i | 0;
	  temp = array[i];
	  array[i] = array[rnd];
	  array[rnd] = temp;
	}

	return array;
}

var BlackJackObject = function() {
	var self = this;
	this.deck = Deck();
	
	this.dealerHidden = true;
	this.dealerHand = []; // weight, weight
	this.hand = [];
	
	this.bet = 100;
	this.myTurn = true;
	
	this.cardIndex = 0;
	
	this.Win = function() {
		// Do Something With .bet
		$.post('http://blackjack/WinBet', JSON.stringify({
			bets: obecnyBet
		}));
		coins = coins + obecnyBet + obecnyBet;
		$('#ownedCoins').empty().append(coins);
		obecnyBet = 100;
		self.myTurn = true;
	}
	
	this.Tie = function() {
		// Do Something With .bet
		$.post('http://blackjack/TieBet', JSON.stringify({
			bets: obecnyBet
		}));
		coins = coins + obecnyBet;
		$('#ownedCoins').empty().append(coins);
		obecnyBet = 100;
		self.myTurn = true;
	}
	
	this.Message = function(info) {
		// Do Something With .bet
		$.post('http://blackjack/Status', JSON.stringify({
			tekst: info
		}));
		self.myTurn = true;
	}
	
	this.Lost = function() {
		// Do Something With .bet
		$.post('http://blackjack/LostBet', JSON.stringify({
			bets: obecnyBet
		}));
		self.myTurn = true;
		if (coins < 100) {
			$.post('http://blackjack/escape2', JSON.stringify({}));
		}
		obecnyBet = 100;
	}
	
	this.getWeight = function(rank, aces) {
		if (rank > 10)
			return 10
		
		if (rank == 1) {
			if (aces)
				return 1;
			
			return 11;
		}
		
		return rank;
	}
	
	this.getPoints = function(arr, aces) {
		if (!aces) // null check
			aces = false;
		
		var points = 0;
		for(var i = 0; i < arr.length; i++)
		{
			points += self.getWeight(arr[i],aces);
		}
		return points;
	}
	
	this.getScore = function(arr) {
		var withAce = self.getPoints(arr, true);
		var withOutAce = self.getPoints(arr, false);
		var score = withOutAce
		
		if (score > 21)
			score = withAce;
		
		return score;
	}
	
	this.didBust = function(arr) {
		var withAce = self.getPoints(arr, true);
		var withOutAce = self.getPoints(arr, false);
		var score = withOutAce
		
		if (score > 21)
			score = withAce;
		
		return (score > 21);
	}
	
	this.willDealerHit = function(arr) { // Dealer hits 16 and under always
		var withAce = self.getPoints(arr, true);
		var withOutAce = self.getPoints(arr, false);
		var score = withOutAce
		
		if (score > 21)
			score = withAce;
		
		return (score < 17); 
	}

	this.IntroRef = function(callBack) {
		var cards = self.deck.cards;
		var len = cards.length;
		
		self.cardIndex = 0;

		__fontSize = window.getComputedStyle(document.body).getPropertyValue('font-size').slice(0, -2);
		
		cards.forEach(function (card, i) {
			card.setSide('back');

			var $el = card.$el;
			var delay = 500 + i * 10;
			var z = i / 4;

			$el.style[transform] = translate(-z + 'px', '-250px');
			$el.style.opacity = 0;

			card.x = -z;
			card.y = -250 - z;
			card.rot = 0;

			card.animateTo({
				delay: delay,
				duration: 1000,

				x: -z,
				y: -z,

				onStart: function onStart() {
					$el.style.zIndex = i;
				},
				onProgress: function onProgress(t) {
					$el.style.opacity = t;
				},
				onComplete: function onComplete() {
					$el.style.opacity = '';
					finishedActions++;
					callBack();
				}
			});
        });
	}
	this.ShuffleRef = function(callBack) {
		var deck = self.deck;
		var cards = deck.cards;
		var len = cards.length;
		
		__fontSize = window.getComputedStyle(document.body).getPropertyValue('font-size').slice(0, -2);
		
		fisherYates(cards);
		self.cardIndex = 0;
		
		cards.forEach(function (card, i) {
			card.setSide('back');
			
			card.pos = i;

			var $el = card.$el;
			
			var i = card.pos;
			var z = i / 4;
			var delay = i * 2;
	
			card.animateTo({
				delay: delay,
				duration: 200,

				x: plusminus(Math.random() * 40 + 20) * __fontSize / 16,
				y: -z,
				rot: 0
			});
			card.animateTo({
				delay: 200 + delay,
				duration: 200,

				x: -z,
				y: -z,
				rot: 0,

				onStart: function onStart() {
					$el.style.zIndex = i;
				},

				onComplete: function onComplete() {
					finishedActions++;
					callBack();
				}
			});
        });
	}
	this.PlayerHitRef = function(callBack) {
		var cards = self.deck.cards;
		var len = cards.length;
		var PlayerHand = self.hand;
		
		var card = cards[self.cardIndex];
		self.cardIndex++;
		PlayerHand.push(card.rank);
		
		var delay = 250;
		__fontSize = window.getComputedStyle(document.body).getPropertyValue('font-size').slice(0, -2);
		
		card.animateTo({
			delay: delay,
			duration: 250,

			x: Math.round(((PlayerHand.length-1) - 2.05) * 70 * __fontSize / 16),
			y: Math.round(-110 * __fontSize / 16),
			rot: 0,

			onStart: function onStart() {
				card.$el.style.zIndex = len - 1 + (PlayerHand.length-1);
				card.setSide('front');
			},
			onComplete: function onComplete() {
				finishedActions++;
				callBack();
			}
		});
	}
	this.DealerHitRef = function(callBack) {
		var cards = self.deck.cards;
		var len = cards.length;
		var DealerHand = self.dealerHand;
		
		var card = cards[self.cardIndex];
		self.cardIndex++;
		DealerHand.push(card.rank);
		
		var delay = 250;
		__fontSize = window.getComputedStyle(document.body).getPropertyValue('font-size').slice(0, -2);
		
		card.animateTo({
			delay: delay,
			duration: 250,

			x: Math.round(((DealerHand.length-1) - 2.05) * 70 * __fontSize / 16),
			y: Math.round(-210 * __fontSize / 16),
			rot: 0,

			onStart: function onStart() {
				card.$el.style.zIndex = len - 1 + (DealerHand.length-1);
				card.setSide('front');
			},
			onComplete: function onComplete() {
				finishedActions++;
				callBack();
			}
		});
	}
	this.DealerHitHideRef = function(callBack) {
		var DealerHitProm = new Promise(function(resolve, reject) {
			var cards = self.deck.cards;
			var len = cards.length;
			var DealerHand = self.dealerHand;
			
			var card = cards[self.cardIndex];
			self.cardIndex++;
			DealerHand.push(card.rank);
			
			var delay = 250;
			__fontSize = window.getComputedStyle(document.body).getPropertyValue('font-size').slice(0, -2);
			
			card.animateTo({
				delay: delay,
				duration: 250,

				x: Math.round(((DealerHand.length-1) - 2.05) * 70 * __fontSize / 16),
				y: Math.round(-210 * __fontSize / 16),
				rot: 0,

				onStart: function onStart() {
					card.$el.style.zIndex = len - 1 + (DealerHand.length-1);
					card.setSide('back');
				},
				onComplete: function onComplete() {
					finishedActions++;
					callBack();
				}
			});
		});
	}
}
var BlackJack = new BlackJackObject();

function queFunc() {
	BlackJack.PlayerHit = BlackJack.deck.queued(BlackJack.PlayerHitRef);
	BlackJack.DealerHit = BlackJack.deck.queued(BlackJack.DealerHitRef);
	BlackJack.DealerHitHide = BlackJack.deck.queued(BlackJack.DealerHitHideRef);
	BlackJack.Intro = BlackJack.deck.queued(BlackJack.IntroRef);
	BlackJack.Shuffle = BlackJack.deck.queued(BlackJack.ShuffleRef);
}
queFunc();

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
			
			if (event.data.enable) {			
				BlackJack.deck.mount($container);
				$.post("http://blackjack/card", JSON.stringify({}));
				queActions(104);
				BlackJack.Intro();
				BlackJack.Shuffle();
				coins = event.data.coins;
				$('#ownedCoins').empty().append(coins);
				BlackJack.myTurn = true;
				$hit.textContent = '[NEW GAME] - Multipler x2';
				$stay.textContent = '[BET UP] +100';
				$score.textContent = '[BET DOWN] -100';
				$('#ownedPoints').empty().append(0);
				$('#ownedBet').empty().append(100);
			} else {
				BlackJack.deck.unmount();
				canEscape = false;
				BlackJack = new BlackJackObject();
				queFunc();
			}
        }
    });
	
    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
			$.post('http://blackjack/escape', JSON.stringify({}));
        }
    };
	
	document.body.style.backgroundColor = "transparent";

	$hit.textContent = '[NEW GAME] - Multipler x2';
	$stay.textContent = '[BET UP] +100';
	$score.textContent = '[BET DOWN] -100';
	$topbar.appendChild($hit);
	$topbar.appendChild($stay);
	$topbar.appendChild($score);

	$hit.addEventListener('click', function () {
		if (!canAct())
			return;
		
		if ($hit.textContent.includes("[NEW GAME] - Multipler x2") && BlackJack.bet >= 100) {
			$.post("http://blackjack/card", JSON.stringify({}));
			$('#ownedPoints').empty().append(0);
			obecnyBet = BlackJack.bet
			$.post('http://blackjack/StartPartia', JSON.stringify({
				bets: obecnyBet
			}));
			$.post("http://blackjack/card", JSON.stringify({}));
			// NEW GAME
			$hit.textContent = "[HIT]";
			coins = coins - BlackJack.bet;
			$('#ownedCoins').empty().append(coins);
			$('#ownedBet').empty().append(BlackJack.bet);
			$stay.textContent = "[STAND]";
			$score.textContent = "Dealer has 0 points;";
			$.post("http://blackjack/card", JSON.stringify({}));
			
			BlackJack.deck.unmount();
			canEscape = false;
			BlackJack = new BlackJackObject();
			queFunc();
			$.post("http://blackjack/card", JSON.stringify({}));
			
			BlackJack.deck.mount($container);
			$.post("http://blackjack/card", JSON.stringify({}));
			queActions(108);
			BlackJack.Shuffle(); // 52
			BlackJack.Shuffle(); // 52
			
			BlackJack.PlayerHit() // 1
			BlackJack.DealerHit() // 1
			BlackJack.PlayerHit() // 1
			BlackJack.DealerHitHide() // 1
			$.post("http://blackjack/card", JSON.stringify({}));
			
			var prom = new Promise(function(res, rej) {
				setInterval(function(){
					if (canAct()) {
						res()
					}
				}, 1000);
			}).then(function() {
				$stay.textContent = "[STAND]";
				$('#ownedPoints').empty().append(BlackJack.getScore(BlackJack.hand));
				$score.textContent = "Dealer has " + BlackJack.getScore(BlackJack.dealerHand.slice(0, 1)) + " points.";
			});
		} else if (BlackJack.myTurn) {
			queActions(1);
			BlackJack.PlayerHit();
			$.post("http://blackjack/card", JSON.stringify({}));
			var prom = new Promise(function(res, rej) {
				setInterval(function(){ 
					if (canAct()) {
						res();
					}
				}, 1000);
			}).then(function() {
				$stay.textContent = "[STAND]";
				$('#ownedPoints').empty().append(BlackJack.getScore(BlackJack.hand));
				
				if (BlackJack.didBust(BlackJack.hand)) {
					$.post("http://blackjack/card", JSON.stringify({}));
					// Did Bust, reset game and set bet to 0;
					BlackJack.Message('You lost having ' + BlackJack.getScore(BlackJack.hand) + ' points.');
					$hit.textContent = '[NEW GAME] - Multipler x2';
					$stay.textContent = '[BET UP] +100';
					$score.textContent = '[BET DOWN] -100';
					$('#ownedPoints').empty().append(0);
					$('#ownedBet').empty().append(100);
					BlackJack.Lost()
				}
			});
			
			// Hit
		}
	})
	
	$stay.addEventListener('click', function () {
		if (!canAct())
			return;
		
		if ($stay.textContent.includes("[BET UP] +100")) {
			//Check to see if can bet up. Then bet up with what ever you are using to handle money.
			BlackJack.bet += 100;

			if (BlackJack.bet > coins) {
				BlackJack.bet = coins;
			}
			$.post("http://blackjack/bet", JSON.stringify({}));
			
			$hit.textContent = '[NEW GAME] - Multipler x2';
			$('#ownedPoints').empty().append(0);
			$('#ownedBet').empty().append(BlackJack.bet);
		} else if (BlackJack.myTurn) {
			BlackJack.myTurn = false;
			BlackJack.deck.cards[3].setSide("front");
			$score.textContent = "Dealer has " + BlackJack.getScore(BlackJack.dealerHand) + " points.";
			
			if (BlackJack.getScore(BlackJack.dealerHand) > BlackJack.getScore(BlackJack.hand)) {
				$.post("http://blackjack/card", JSON.stringify({}));
				$hit.textContent = '[NEW GAME] - Multipler x2';
				$('#ownedPoints').empty().append(0);
				$('#ownedBet').empty().append(100);
				$stay.textContent = '[BET UP] +100';
				$score.textContent = '[BET DOWN] -100';
				BlackJack.Lost();
				BlackJack.Message('You lost ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
				$('#ownedBet').empty().append(100);
				queActions(0);
			} else if (BlackJack.getScore(BlackJack.dealerHand) == BlackJack.getScore(BlackJack.hand)) {
				$.post("http://blackjack/card", JSON.stringify({}));
				$hit.textContent = '[NEW GAME] - Multipler x2';
				$('#ownedPoints').empty().append(0);
				$('#ownedBet').empty().append(100);
				$stay.textContent = '[BET UP] +100';
				$score.textContent = '[BET DOWN] -100';
				BlackJack.Tie();
				BlackJack.Message('You tied ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
				$('#ownedBet').empty().append(100);
				queActions(0);
			} else if (!BlackJack.willDealerHit(BlackJack.dealerHand)) {
				$.post("http://blackjack/card", JSON.stringify({}));
				$hit.textContent = '[NEW GAME] - Multipler x2';
				$('#ownedPoints').empty().append(0);
				$('#ownedBet').empty().append(100);
				$stay.textContent = '[BET UP] +100';
				$score.textContent = '[BET DOWN] -100';
				BlackJack.Win();
				BlackJack.Message('You won ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
				$('#ownedPoints').empty().append(0);
				$('#ownedBet').empty().append(100);
				queActions(0);
			} else {
				var lastIndex = BlackJack.cardIndex;
				var curIndex = lastIndex++;
				var nextScore = 0;
				
				var drawCards = 0;
				
				var tmparr = BlackJack.dealerHand.slice();
				
				for(var i = 0; i < 6; i++) { // Max 7 cards
					var cardRank = BlackJack.deck.cards[curIndex+i].rank;
					tmparr.push(cardRank);
					
					nextScore = BlackJack.getScore(tmparr);
					
					drawCards++;
					
					if (nextScore >= BlackJack.getScore(BlackJack.hand)) // Higher score than player, don't need to keep going might bust
						break;
					
					if (nextScore >= 17) // Stop After 16
						break;
				}
				
				queActions(drawCards);
				for(var c = 0; c < drawCards; c++) {
					BlackJack.DealerHit();
				}
				
				var prom = new Promise(function(res, rej) {
				setInterval(function(){ 
						if (canAct()) {
							res();
						}
					}, 1000);
				}).then(function() {
					$stay.textContent = "[STAND]";
					$('#ownedPoints').empty().append(BlackJack.getScore(BlackJack.hand));
					
					if (BlackJack.didBust(BlackJack.dealerHand)) {
						$.post("http://blackjack/card", JSON.stringify({}));
						$hit.textContent = '[NEW GAME] - Multipler x2';
						$('#ownedPoints').empty().append(0);
						$('#ownedBet').empty().append(100);
						$stay.textContent = '[BET UP] +100';
						$score.textContent = '[BET DOWN] -100';
						BlackJack.Win();
						BlackJack.Message('You won ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
						$('#ownedPoints').empty().append(0);
						$('#ownedBet').empty().append(100);
					} else if (BlackJack.getScore(BlackJack.dealerHand) > BlackJack.getScore(BlackJack.hand)) {
						$.post("http://blackjack/card", JSON.stringify({}));
						$hit.textContent = '[NEW GAME] - Multipler x2';
						$stay.textContent = '[BET UP] +100';
						$score.textContent = '[BET DOWN] -100';
						BlackJack.Lost();
						BlackJack.Message('You lost ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
						$('#ownedPoints').empty().append(0);
						$('#ownedBet').empty().append(100);
					} else if (BlackJack.getScore(BlackJack.dealerHand) == BlackJack.getScore(BlackJack.hand)) {
						$.post("http://blackjack/card", JSON.stringify({}));
						$hit.textContent = '[NEW GAME] - Multipler x2';
						$('#ownedPoints').empty().append(0);
						$('#ownedBet').empty().append(100);
						$stay.textContent = '[BET UP] +100';
						$score.textContent = '[BET DOWN] -100';
						BlackJack.Tie();
						BlackJack.Message('You tied ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
						$('#ownedPoints').empty().append(0);
						$('#ownedBet').empty().append(100);
						queActions(0);
					} else {
						$.post("http://blackjack/card", JSON.stringify({}));
						$hit.textContent = '[NEW GAME] - Multipler x2';
						$stay.textContent = '[BET UP] +100';
						$score.textContent = '[BET DOWN] -100';
						BlackJack.Win();
						BlackJack.Message('You won ' + BlackJack.getScore(BlackJack.hand) + ' to ' + BlackJack.getScore(BlackJack.dealerHand) + ".");
						$('#ownedPoints').empty().append(0);
						$('#ownedBet').empty().append(100);
					}
					queActions(0)
				});
			}
			queActions(0)
		}
	})
	
	$score.addEventListener('click', function () {
		if (!canAct())
			return;
		
		if ($score.textContent.includes("[BET DOWN] -100")) {
			$.post("http://blackjack/bet", JSON.stringify({}));
			//Check to see if can bet down. Then bet down with what ever you are using to handle money.
			BlackJack.bet -= 100;
			
			if (BlackJack.bet < 100)
				BlackJack.bet = 100;
			
			$hit.textContent = '[NEW GAME] - Multipler x2';
			$('#ownedBet').empty().append(BlackJack.bet);
		} else {
		}
	})
});
