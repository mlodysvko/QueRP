(function(){
	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
			'<div class="head"><span>{{{title}}}</span></div>' +
				'<div class="menu-items">' + 
					'{{#elements}}' +
						'<div class="menu-item {{#selected}}selected{{/selected}}">' +
							'{{#hasIcon}}<img src="{{{icon}}}">{{/hasIcon}}<div>{{{label}}}{{#isSlider}}: <span>&lt; {{{sliderLabel}}} &gt;</span><input type="text" style="display: none;">{{/isSlider}}</div>{{#isShortcut}}<div class="slot">{{{slot}}}</div>{{/isShortcut}}' +
						'</div>' +
					'{{/elements}}' +
				'</div>'+
			'</div>' +
		'</div>'
	;

	window.ESX_MENU       = {};
	ESX_MENU.ResourceName = 'esx_menu_default';
	ESX_MENU.focused      = false;
	ESX_MENU.opened       = {};
	ESX_MENU.focus	      = [];
	ESX_MENU.pos	      = {};
	ESX_MENU.brokenIcons  = [];

	ESX_MENU.handleScroll = function(name) {
		let obj = $(name).find('.menu-item.selected')[0]
		if(typeof obj !== 'undefined')
			obj.scrollIntoView();
	};

	ESX_MENU.open = function(namespace, name, data){
		if(typeof ESX_MENU.opened[namespace] == 'undefined')
			ESX_MENU.opened[namespace] = {};

		if(typeof ESX_MENU.opened[namespace][name] != 'undefined')
			ESX_MENU.close(namespace, name);

		if(typeof ESX_MENU.pos[namespace] == 'undefined')
			ESX_MENU.pos[namespace] = {};

		for(let i=0; i<data.elements.length; i++)
			if(typeof data.elements[i].type == 'undefined')
				data.elements[i].type = 'default';

		data._index     = ESX_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		for(let i = 0; i < data.elements.length; i++){
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		}

		ESX_MENU.opened[namespace][name] = data;
		ESX_MENU.pos   [namespace][name] = 0;

		for(let i = 0; i < data.elements.length; i++){
			if(data.elements[i].selected)
				ESX_MENU.pos[namespace][name] = i;
			else
				data.elements[i].selected = false
		}

		ESX_MENU.focus.push({
			namespace: namespace,
			name     : name
		});

		ESX_MENU.render();
		ESX_MENU.handleScroll('#menu_' + namespace + '_' + name);
	}

	ESX_MENU.close = function(namespace, name){
		delete ESX_MENU.opened[namespace][name];
		for(let i = 0; i < ESX_MENU.focus.length; i++){
			if(ESX_MENU.focus[i].namespace == namespace && ESX_MENU.focus[i].name == name){
				ESX_MENU.focus.splice(i, 1);
				break;
			}
		}

		ESX_MENU.render();
	}

	ESX_MENU.render = function(){
		let menuContainer       = document.getElementById('menus');
		let focused	     = ESX_MENU.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();
		for(let namespace in ESX_MENU.opened){
			for(let name in ESX_MENU.opened[namespace]){
				let menuData = ESX_MENU.opened[namespace][name];

				let view = JSON.parse(JSON.stringify(menuData))
				for(let i = 0; i < menuData.elements.length; i++){
					let element = view.elements[i];
					if(element.type == 'slider'){
						element.isSlider = true;
						element.sliderLabel = (typeof element.options == 'undefined') ? element.value : element.options[element.value];
					} else {
						if(element.slot) {
							element.isShortcut = true;
						}

						if(element.icon !== undefined) {
							element.hasIcon = true;
							if(ESX_MENU.brokenIcons.indexOf(element.icon) !== -1) {
								element.icon = 'img/empty.png';
							}
						}
					}

					if(i == ESX_MENU.pos[namespace][name])
						element.selected = true;
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).find('img').each(function() {
					this.onerror = () => {
						if(ESX_MENU.brokenIcons.indexOf(this.src) === -1) {
							ESX_MENU.brokenIcons.push(this.src);
						}

						this.src = 'img/empty.png';
					};
				});

				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if(typeof focused != 'undefined')
			$('#menu_' + focused.namespace + '_' + focused.name).show();

		$(menuContainer).show();

	}

	ESX_MENU.submit = function(namespace, name, data) {
		let e = [];
		for(let i = 0; i < ESX_MENU.opened[namespace][name].elements.length; i++){
			e[i] = {
				label   : ESX_MENU.opened[namespace][name].elements[i].label,
				value   : ESX_MENU.opened[namespace][name].elements[i].value,
				selected: ESX_MENU.opened[namespace][name].elements[i].selected
			}
		}

		$.post('https://' + ESX_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : e
		}));
	}

	ESX_MENU.cancel = function(namespace, name, data) {
		$.post('https://' + ESX_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	}

	ESX_MENU.change = function(namespace, name, data) {
		let e = [];
		for(let i = 0; i < ESX_MENU.opened[namespace][name].elements.length; i++){
			e[i] = {
				label   : ESX_MENU.opened[namespace][name].elements[i].label,
				value   : ESX_MENU.opened[namespace][name].elements[i].value,
				selected: ESX_MENU.opened[namespace][name].elements[i].selected
			}
		}

		$.post('https://' + ESX_MENU.ResourceName + '/menu_change', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : e
		}));
	}

	ESX_MENU.delete = function(namespace, name, data) {
		$.post('https://' + ESX_MENU.ResourceName + '/menu_delete', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data
		}));
	}

	ESX_MENU.shortcut = function(namespace, name, control, data) {
		$.post('https://' + ESX_MENU.ResourceName + '/menu_shortcut', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			control   : control,
			current   : data
		}));
	}

	ESX_MENU.getFocused = function(){
		let l = ESX_MENU.focus.length;
		if(l > 0)
			return ESX_MENU.focus[l - 1];

		return undefined;
	}

	window.onData = (data) => {
		switch(data.action){
			case 'openMenu' : {
				ESX_MENU.open(data.namespace, data.name, data.data);
				break;
			}
			case 'closeMenu' : {
				ESX_MENU.close(data.namespace, data.name);
				break;
			}
			case 'focusMenu' : {
				ESX_MENU.focused = data.focus;
				break;
			}
			case 'shortcut' : {
				let focused = ESX_MENU.getFocused();
				if(typeof focused != 'undefined'){
					let menu = ESX_MENU.opened[focused.namespace][focused.name];
					let pos = ESX_MENU.pos[focused.namespace][focused.name];
					if(menu.elements.length > 0)
						ESX_MENU.shortcut(focused.namespace, focused.name, data.control, menu.elements[pos]);
				}
				break;
			}
			case 'controlPressed' : {
				switch(data.control) {
					case 'ENTER' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0)
								ESX_MENU.submit(focused.namespace, focused.name, menu.elements[pos]);
						}

						break;
					}

					case 'BACKSPACE' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined')
							ESX_MENU.cancel(focused.namespace, focused.name);

						break;
					}

					case 'NENTER' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0){
								let elem = menu.elements[pos];
								if(elem){
									if(elem.type == 'slider'){
										let span = $('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected span');
										if(span.is(':visible')){
											span.css('display', 'none');
											let oldValue = elem.value;

											let input = $('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected input');
											input.css('display', 'inline');
											input.val(oldValue);
											input.focus();

											$.post('https://' + ESX_MENU.ResourceName + '/menu_focus', JSON.stringify({ focus: true }));
											setTimeout(function() {
												$(input).on('keyup', function(e){
													if(e.which == 13){
														$(input).off(e);

														let curr = parseInt(input.val());
														if(curr.toString() == input.val() && curr != elem.value){
															let restrict = (typeof elem.restrict == 'undefined') ? [] : elem.restrict;
															let min = (typeof elem.min == 'undefined') ? 0 : elem.min;

															let max = null;
															if(typeof elem.options != 'undefined' && elem.value < (elem.options.length - 1))
																max = (elem.options.length - 1);

															if(typeof elem.max != 'undefined' && elem.value < elem.max)
																max = elem.max;

															if(restrict.includes(curr)){
																curr = oldValue;
																elem.restricted = true;
															}else if(curr < min || (max != null && curr > max)){
																curr = 0;
															}

															elem.value = curr;
														}else{
															elem.value = oldValue;
														}

														ESX_MENU.change(focused.namespace, focused.name, elem);
														ESX_MENU.render();
													}else if(e.which == 27){
														$(input).off(e);
														ESX_MENU.change(focused.namespace, focused.name, elem);
														ESX_MENU.render();
													}
												});
											}, 250);
										}
									}else{
										ESX_MENU.submit(focused.namespace, focused.name, menu.elements[pos]);
									}
								}
							}
						}

						break;
					}

					case 'DELETE' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0){
								let elem = menu.elements[pos];
								switch(elem.type) {
									case 'item_money' :
									case 'item_weapon' :
									case 'item_account' :
									case 'item_standard' : {
										if(menu.elements.length > 0)
											ESX_MENU.delete(focused.namespace, focused.name, elem);

										break;

									}
									case 'slider' : {
										let value = (typeof elem.min == 'undefined') ? 0 : elem.min;
										if(value != elem.value){
											elem.value = value;
											ESX_MENU.change(focused.namespace, focused.name, elem);
										}

										ESX_MENU.render()
										break;

									}
									default: break;
								}

								ESX_MENU.handleScroll('#menu_' + focused.namespace + '_' + focused.name);
							}
						}

						break;
					}

					case 'TOP' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0){
								if(pos > 0)
									ESX_MENU.pos[focused.namespace][focused.name]--;
								else
									ESX_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;

								pos = ESX_MENU.pos[focused.namespace][focused.name];
								for(let i = 0; i < menu.elements.length; i++) {
									if(i == pos)
										menu.elements[i].selected = true
									else
										menu.elements[i].selected = false
								}

								ESX_MENU.change(focused.namespace, focused.name, menu.elements[pos]);
								ESX_MENU.render();
								ESX_MENU.handleScroll('#menu_' + focused.namespace + '_' + focused.name);
							}
						}

						break;

					}

					case 'DOWN' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0){
								let length = menu.elements.length;
								if(pos < length - 1)
									ESX_MENU.pos[focused.namespace][focused.name]++;
								else
									ESX_MENU.pos[focused.namespace][focused.name] = 0;

								pos = ESX_MENU.pos[focused.namespace][focused.name];
								for(let i = 0; i < menu.elements.length; i++) {
									if(i == pos)
										menu.elements[i].selected = true
									else
										menu.elements[i].selected = false
								}

								ESX_MENU.change(focused.namespace, focused.name, menu.elements[pos]);
								ESX_MENU.render();
								ESX_MENU.handleScroll('#menu_' + focused.namespace + '_' + focused.name);
							}
						}

						break;
					}

					case 'LEFT' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0){
								let elem  = menu.elements[pos];
								if(elem && elem.type == 'slider'){
									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;
									let restrict = (typeof elem.restrict == 'undefined') ? [] : elem.restrict;

									let curr = elem.value;
									if(curr > min){
										while(true){
											curr--;
											if(!restrict.includes(curr))
												break;
											else if(curr == min){
												curr = elem.value;
												break;
											}										
										}

										elem.value = curr;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									ESX_MENU.render();
								}

								ESX_MENU.handleScroll('#menu_' + focused.namespace + '_' + focused.name);
							}
						}

						break;
					}

					case 'RIGHT' : {
						let focused = ESX_MENU.getFocused();
						if(typeof focused != 'undefined'){
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos = ESX_MENU.pos[focused.namespace][focused.name];
							if(menu.elements.length > 0){
								let elem = menu.elements[pos];
								if(elem && elem.type == 'slider'){
									let restrict = (typeof elem.restrict == 'undefined') ? [] : elem.restrict;
									let curr = elem.value;

									let max = null;
									if(typeof elem.options != 'undefined' && elem.value < (elem.options.length - 1))
										max = (elem.options.length - 1);

									if(typeof elem.max != 'undefined' && elem.value < elem.max)
										max = elem.max;

									if(max != null && curr < max){
										while(true){
											curr++;
											if(!restrict.includes(curr))
												break;
											else if(curr == max){
												curr = elem.value;
												break;
											}										
										}

										elem.value = curr;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									ESX_MENU.render();
								}

								ESX_MENU.handleScroll('#menu_' + focused.namespace + '_' + focused.name);
							}
						}

						break;
					}
					default : break;
				}

				break;
			}
		}
	}

	window.onload = function(e){
		window.addEventListener('message', (event) => {
			onData(event.data)
		});
	}
})()