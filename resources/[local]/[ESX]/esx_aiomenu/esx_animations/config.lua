Config = {}
Config.Animations = {
	{
		name  = 'interakcje',
		label = 'Interakcje z obywatelem',
		items = {
			{label = "Powitaj", keyword = "powitaj", type = "wspolne", data = { name = 'powitaj', anim = {lib = 'mp_ped_interaction', anim = 'hugs_guy_a'} }},		
			{label = "Przytul", keyword = "przytul", type = "wspolne", data = { name = 'przytul', anim = {lib = 'mp_ped_interaction', anim = 'kisses_guy_b'} }},
			{label = "Pocałuj", keyword = "pocaluj", type = "wspolne", data = { name = 'pocaluj', anim = {lib = 'mp_ped_interaction', anim = 'kisses_guy_a'} }},
			{label = "Przenieś", keyword = "przenies", type = "wspolne", data = { name = 'przenies' }},	
			{label = "Uderz", keyword = "uderz", type = "wspolne", data = { name = 'uderz', anim = {lib = 'anim@gangops@hostage@', anim = 'victim_fail'}, anim2 = {lib = 'melee@unarmed@streamed_variations', anim = 'plyr_takedown_rear_lefthook'} }},
			{label = "Uderz 2", keyword = "uderz2", type = "wspolne", data = { name = 'uderz2', anim = {lib = 'anim@gangops@hostage@', anim = 'victim_fail'}, anim2 = {lib = 'melee@unarmed@streamed_variations', anim = 'plyr_takedown_front_backslap'} }},
			{label = "Usiądź", keyword = "siad", type = "wspolne", data = { name = 'siad', anim = {lib = 'timetable@reunited@ig_10', anim = 'base_amanda'}, anim2 = {lib = 'timetable@ron@ig_5_p3', anim = 'ig_5_p3_base'} }},
			{label = "Piatka", keyword = "piatka", type = "wspolne", data = { name = 'piatka', anim = {lib = 'mp_ped_interaction', anim = 'highfive_guy_a'}, anim2 = {lib = 'mp_ped_interaction', anim = 'highfive_guy_b'} }},		
			{label = "Przytul Po Przyjacielsku", keyword = "przytulpoprzyjacielsku", type = "wspolne", data = { name = 'przytulpoprzyjacielsku', anim = {lib = 'mp_ped_interaction', anim = 'hugs_guy_a'}, anim2 = {lib = 'mp_ped_interaction', anim = 'hugs_guy_b'} }},	
			{label = "Wspolny Taniec1", keyword = "wspolnytaniec1", type = "wspolne", data = { name = 'wspolnytaniec1', anim = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'low_center'}, anim2 = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'low_center'} }},	
			{label = "Wspolny Taniec2", keyword = "wspolnytaniec2", type = "wspolne", data = { name = 'wspolnytaniec2', anim = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v1_female^1'}, anim2 = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v1_female^1'} }},	
			{label = "Wspolny Taniec3", keyword = "wspolnytaniec3", type = "wspolne", data = { name = 'wspolnytaniec3', anim = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'high_center'}, anim2 = {lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'high_center'} }},
			{label = "Wspolny Taniec4", keyword = "wspolnytaniec4", type = "wspolne", data = { name = 'wspolnytaniec4', anim = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v2_female^1'}, anim2 = {lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v2_female^1'} }},
			{label = "Wspolny Taniec5", keyword = "wspolnytaniec5", type = "wspolne", data = { name = 'wspolnytaniec5', anim = {lib = 'anim@amb@nightclub@dancers@solomun_entourage@', anim = 'mi_dance_facedj_17_v1_female^1'}, anim2 = {lib = 'anim@amb@nightclub@dancers@solomun_entourage@', anim = 'mi_dance_facedj_17_v1_female^1'} }},
			{label = "Wspolny Taniec6", keyword = "wspolnytaniec6", type = "wspolne", data = { name = 'wspolnytaniec6', anim = {lib = 'anim@amb@nightclub@lazlow@hi_podium@', anim = 'danceidle_mi_17_crotchgrab_laz'}, anim2 = {lib = 'anim@amb@nightclub@lazlow@hi_podium@', anim = 'danceidle_mi_17_crotchgrab_laz'} }},
			{label = "Wspolny Taniec7", keyword = "wspolnytaniec7", type = "wspolne", data = { name = 'wspolnytaniec7', anim = {lib = 'anim@mp_player_intcelebrationmale@uncle_disco', anim = 'uncle_disco'}, anim2 = {lib = 'anim@mp_player_intcelebrationmale@uncle_disco', anim = 'uncle_disco'} }},
			{label = "Zrób loda (na stojąco)", keyword = "lodzik", type = "wspolne", data = { name = 'lodzik', anim = {lib = 'misscarsteal2pimpsex', anim = 'pimpsex_hooker'}, anim2 = {lib = 'misscarsteal2pimpsex', anim = 'pimpsex_punter'} }},
			{label = "Sex (na stojąco)", keyword = "sexik", type = "wspolne", data = { name = 'sexik', anim = {lib = 'misscarsteal2pimpsex', anim = 'shagloop_hooker'}, anim2 = {lib = 'misscarsteal2pimpsex', anim = 'shagloop_pimp'} }},
			{label = "Lodzik", keyword = "lodzik", type = "wspolne", data = { name = 'lodzik', anim = {lib = 'random@getawaydriver', anim = 'idle_a'}, anim2 = {lib = 'anim@mp_player_intupperair_shagging', anim = 'idle_a'} }},
			{label = "Gra w Baseballa", keyword = "baseball", type = "wspolne", data = { name = 'baseball', anim = {lib = 'anim@arena@celeb@flat@paired@no_props@', anim = 'baseball_a_player_a'}, anim2 = {lib = 'anim@arena@celeb@flat@paired@no_props@', anim = 'baseball_a_player_b'} }},
			{label = "Żółwik", keyword = "zolwik", type = "wspolne", data = { name = 'zolwik', anim = {lib = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', anim = 'fist_bump_left'}, anim2 = {lib = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', anim = 'fist_bump_right'} }},				
		}
	},
	
	{
		name  = 'rannys',
		label = 'Ranny / Medyczne',
		items = {
			{label = "Postrzelony", keyword = "postrzelony", type = "anim", data = {lib = "random@dealgonewrong", anim = "idle_a", mode = 1}},
			{label = "Postrzelony 2", keyword = "postrzelony2", type = "anim", data = {lib = "random@dealgonewrong", anim = "idle_a", mode = 51}},
			{label = "RKO", keyword = "rko", type = "anim", data = {lib = "missheistfbi3b_ig8_2", anim = "cpr_loop_paramedic", mode = 1}},
			{label = "Postrzał w brzuch", keyword = "postrzal", type = "anim", data = {lib = "random@crash_rescue@wounded@base", anim = "base", mode = 1}},
			{label = "Ból brzucha", keyword = "bol", type = "anim", data = {lib = "combat@damage@writheidle_a", anim = "writhe_idle_a", mode = 1}},
			{label = "Ból głowy", keyword = "bol2", type = "anim", data = {lib = "combat@damage@writheidle_b", anim = "writhe_idle_f", mode = 1}},
			{label = "Ból nogi", keyword = "bol3", type = "anim", data = {lib = "combat@damage@writheidle_b", anim = "writhe_idle_e", mode = 1}},
			{label = "Ból pleców", keyword = "bol4", type = "anim", data = {lib = "anim@move_lester", anim = "idle_a", mode = 49}},
			{label = "Ból serca", keyword = "bol5", type = "anim", data = {lib = "rcmfanatic1out_of_breath", anim = "p_zero_tired_01"}},
			{label = "Wymiotowanie do toalety", keyword = "wymiotowanie", type = "anim", data = {lib = "timetable@tracy@ig_7@idle_a", anim = "idle_a", mode = 1}},
			{label = "Po uderzeniu w głowę", keyword = "uderzeniewglowe", type = "anim", data = {lib = "misscarsteal4@actor", anim = "stumble"}},
			{label = "Po uderzeniu w głowę v2", keyword = "uderzeniewglowe2", type = "anim", data = {lib = "misscarsteal4@actor", anim = "dazed_idle", mode = 49}}
		}
	},

	{
		name  = 'greetings',
		label = 'Pozdrowienia',
		items = {
			{label = "Machnięcię ręką", keyword = "machanie", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
			{label = "Powitanie", keyword = "powitanie", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
			{label = "Graba", keyword = "graba", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
			{label = "Graba i klepanie po plecach", keyword = "graba2", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
			{label = "Żółwik", keyword = "zolwik", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
			{label = "Salut", keyword = "salut", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute", mode = 49}},
			{label = "Srodkowy palec", keyword = "fuck", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
			{label = "Srodkowy palec v2", keyword = "fuck2", type = "anim", data = {lib = "mp_player_intfinger", anim = "mp_player_int_finger"}},
			{label = "Środkowy palec v3", keyword = "fuck3", type = "anim", data = {lib = "anim@mp_player_intselfiethe_bird", anim = "idle_a", mode = 49}},
			{label = "Poslanie buziaczka", keyword = "buziak", type = "anim", data = {lib = "anim@mp_player_intselfieblow_kiss", anim = "exit", mode = 48}},
			{label = "Machanie ręką", keyword = "machanie", type = "anim", data = {lib = "random@hitch_lift", anim = "come_here_idle_c", mode = 49}}
		}
	},

	{
		name = 'interaction',
		label = 'Interakcja',
		items = {
			{label = "Bankomat", keyword = "bankomat", type = "scenario", data = {anim = "PROP_HUMAN_ATM"}},
			{label = "Pisanie na klawiaturze", keyword = "klawiatura", type = "anim", data = {lib = "anim@heists@prison_heiststation@cop_reactions", anim =  "cop_b_idle", mode = 51}},
			{label = "Pisanie na klawiaturze 2", keyword = "klawiatura2", type = "anim", data = {lib = "mp_prison_break", anim = "hack_loop", mode = 1}},
			{label = "Pisanie na klawiaturze 3", keyword = "klawiatura3", type = "anim", data = {lib = "mp_fbi_heist", anim = "loop", mode = 51}},					
			{label = "Notes", keyword = "notes", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"}},
			{label = "Założone ręce", keyword = "foch", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", mode = 49}},
			{label = "Założone ręce v2", keyword = "foch2", type = "anim", data = {lib = "anim@amb@nightclub@peds@", anim = "rcmme_amanda1_stand_loop_cop", mode = 49}},
			{label = "Oprzyj się", keyword = "oprzyj", type = "anim", data = {lib = "amb@prop_human_bum_shopping_cart@male@base", anim = "base", mode = 1}},
			{label = "Kciuk w górę", keyword = "kciuk", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_uplow@ds@", anim = "idle_a", mode = 49}},
			{label = "Kciuk w dół", keyword = "kciuk2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_a"}},
			{label = "Dłubanie w nosie", keyword = "nos", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@nose_pick", anim = "nose_pick", mode = 49}},
			{label = "Wybierz mnie", keyword = "mnie", type = "anim", data = {lib = "missmic4premiere", anim = "crowd_b_idle_01"}},
			{label = "Głupio wyszło", keyword = "glupio", type = "anim", data = {lib = "missmic4premiere", anim = "interview_short_anton"}},
			{label = "Przykro mi", keyword = "przykro", type = "anim", data = {lib = "missmurder", anim = "idle"}},
			{label = "Niegrzeczny palec", keyword = "niegrzeczny", type = "anim", data = {lib = "anim@mp_player_intincarno_waystd@ps@", anim = "enter"}},
			{label = "Stopowicz", keyword = "stopowicz", type = "anim", data = {lib = "random@hitch_lift", anim = "idle_f", mode = 1}},
			{label = "Łapie za głowę", keyword = "glowa", type = "anim", data = {lib = "random@mugging3", anim = "agitated_loop_b"}},
			{label = "Metal", keyword = "metal", type = "anim", data = {lib = "anim@mp_player_intincarrockstd@ps@", anim = "idle_a", mode = 49}}		
	    }
	},

	{
		name = 'poses',
		label = 'Pozy',
		items = {
			{label = "Samolot", keyword = "samolot", type = "anim", data = {lib = "missfbi1", anim = "ledge_loop", mode = 49}},
			{label = "Medytowanie", keyword = "medytowanie", type = "anim", data = {lib = "rcmcollect_paperleadinout@", anim = "meditiate_idle", mode = 1}},
			{label = "Medytowanie 2", keyword = "medytowanie2", type = "anim", data = {lib = "rcmepsilonism3", anim = "base_loop", mode = 1}},
			{label = "Medytowanie 3", keyword = "medytowanie3", type = "anim", data = {lib = "rcmcollect_paperleadinout@", anim = "meditiate_idle", mode = 51}},
			{label = "Myślenie", keyword = "myslenie", type = "anim", data = {lib = "mp_cp_welcome_tutthink", anim = "b_think", mode = 1}},			
			{label = "Myślenie 2", keyword = "myslenie2", type = "anim", data = {lib = "misscarsteal4@aliens", anim = "rehearsal_base_idle_director", mode = 1}},			
			{label = "Myślenie 3", keyword = "myslenie3", type = "anim", data = {lib = "timetable@tracy@ig_8@base", anim = "base", mode = 1}},		
			{label = "Myślenie 4", keyword = "myslenie4", type = "anim", data = {lib = "misscarsteal4@aliens", anim = "rehearsal_base_idle_director", mode = 51}},			
			{label = "Opieranie się o ladę", keyword = "opieranie", type = "anim", data = {lib = "anim@amb@clubhouse@bar@drink@idle_a", anim = "idle_a_bartender", mode = 51}},
			{label = "Opieranie się o ladę 2", keyword = "opieranie2", type = "anim", data = {lib = "amb@prop_human_bum_shopping_cart@male@idle_a", anim = "idle_c", mode = s1}},						
			{label = "Opieranie się o ladę 3", keyword = "opieranie3", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@ig1_vip@", anim = "clubvip_base_laz", mode = s1}},						
			{label = "Ochroniarz", keyword = "ochroniarz", type = "scenario", data = {anim = "WORLD_HUMAN_GUARD_STAND"}},
			{label = "Guard", keyword = "guard", type = "anim", data = {lib = "amb@world_human_stand_guard@male@base", anim = "base", mode = 49}},
			{label = "Biodra", keyword = "biodra", type = "anim", data = {lib = "random@shop_tattoo", anim = "_idle", mode = 49}},
			{label = "Palce na biodra", keyword = "biodra2", type = "anim", data = {lib = "amb@world_human_cop_idles@female@base", anim = "base", mode = 49}},
			{label = "Biodra i pas", keyword = "biodra3", type = "anim", data = {lib = "amb@world_human_cop_idles@male@idle_b", anim = "idle_e", mode = 49}},
			{label = "Policjant", keyword = "policjant", type = "scenario", data = {anim = "WORLD_HUMAN_COP_IDLES"}},
			{label = "Cop", keyword = "cop", type = "anim", data = {lib = "amb@code_human_wander_idles_cop@male@static", anim = "static", mode = 49}},
			{label = "Bandzior", keyword = "bandzior", type = "scenario", data = {anim = "WORLD_HUMAN_HIKER_STANDING"}},
			{label = "Luźno", keyword = "luzno", type = "anim", data = {lib = "amb@world_human_stand_impatient@female@no_sign@base", anim = "base", mode = 1}},
			{label = "Zastanowienie", keyword = "zastanowienie", type = "anim", data = {lib = "amb@world_human_prostitute@cokehead@base", anim = "base", mode = 49}},
			{label = "Niespokojny", keyword = "niespokojny", type = "anim", data = {lib = "amb@world_human_drug_dealer_hard@male@idle_a", anim = "idle_c", mode = 1}},
			{label = "Wyzywająca", keyword = "wyzywajaca", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arm_side@idle_a", anim = "idle_b", mode = 1}},
			{label = "Nuda", keyword = "nuda", type = "loop", data = {base = {lib = "amb@world_human_hang_out_street@female_hold_arm@enter", anim = "enter", length = 3600, entering = true}, idle = {lib = "amb@world_human_hang_out_street@female_hold_arm@base", anims = {{"base", 2500}}}, finish = {lib = "amb@world_human_hang_out_street@female_hold_arm@exit", anim = "exit", length = 2500}, mode = 0}},
			{label = "Zmęczenie", keyword = "zmeczenie", type = "anim", data = {lib = "rcmfanatic3leadinoutef_3_mcs_1", anim = "fra_outofbreath_loop", mode = 1}},
			{label = "W kieszeni", keyword = "wkieszeni", type = "anim", data = {lib = "rcmjosh1", anim = "idle", mode = 49}},
			{label = "Panika", keyword = "panika", type = "anim", data = {lib = "rcmlastone1", anim = "convict_idleshort", mode = 1}},
			{label = "Zniecierpliwienie", keyword = "zniecierpliwienie", type = "anim", data = {lib = "rcmme_tracey1", anim = "nervous_loop", mode = 1}},
			{label = "Myśliciel", keyword = "mysliciel", type = "anim", data = {lib = "rcmnigel3_idles", anim = "base_nig", mode = 49}},
			{label = "Drążenie butem", keyword = "butem", type = "anim", data = {lib = "anim@mp_freemode_return@f@idle", anim = "idle_c", mode = 1}}
			
		}
	},

	{
		name  = 'conversation',
		label = 'Konwersacja',
		items = {
			{label = "Drapanie sie po glowie", keyword = "drapanie", type = "anim", keyword = "hm", data = {lib = "mp_cp_stolen_tut", anim = "b_think", mode = 48}},
			{label = "Jest Dobrze!", keyword = "jd", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@thumbs_up", anim = "thumbs_up"}},
			{label = "Przytulanie", keyword = "przytul", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
			{label = "Spokojnie", keyword = "spokojnie", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
			{label = "Zdziwienie", keyword = "zdziwienie", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
			{label = "A niech to licho!", keyword = "licho", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
			{label = "Super", keyword = "super", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
			{label = "No i co z tego?", keyword = "ico", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
			{label = "Ja", keyword = "ja", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
			{label = "Klęczenie", keyword = "kleczenie", type = "anim", data = {lib = "amb@medic@standing@kneel@base", anim = "base", mode = 2}},
			{label = "Zestresowana", keyword = "zestresowana", type = "anim", data = {lib = "random@hitch_lift", anim = "f_distressed_loop"}}
		}
	},

	{
		name  = 'leaning',
		label = 'Siadanie / Leżenie / Opieranie',
		items = {
			{label = "Menel", keyword = "menel", type = "scenario", data = {anim = "WORLD_HUMAN_PICNIC"}},
			{label = "Menel (M)", keyword = "menelm", type = "anim", data = {lib = "amb@world_human_picnic@male@base", anim = "base", mode = 1}},
			{label = "Menel (K)", keyword = "menelk", type = "anim", data = {lib = "amb@world_human_picnic@female@base", anim = "base", mode = 1}},
			{label = "Usiądź", keyword = "usiadz", type = "anim", data = {lib = "switch@michael@sitting", anim = "idle", mode = 1}},
			{label = "Usiądź przechylone", keyword = "usiadz2", type = "anim", data = {lib = "timetable@amanda@ig_7", anim = "base", mode = 1}},
			{label = "Usiądź na kanapie", keyword = "usiadz3", type = "anim", data = {lib = "timetable@maid@couch@", anim = "base", mode = 1}},
			{label = "Usiądź na kanapie v2", keyword = "usiadz4", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_jimmy", mode = 1}},
			{label = "Usiądź noga na noge", keyword = "usiadz5", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_amanda", mode = 1}},
			{label = "Usiądź zgarbiony", keyword = "usiadz6", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "base", mode = 1}},
			{label = "Usiądź na kibel", keyword = "usiadz7", type = "anim", data = {lib = "timetable@trevor@on_the_toilet", anim = "trevonlav_baseloop", mode = 1}},
			{label = "Losowe opieranie się", keyword = "lopieranie", type = "scenario", data = {anim = "WORLD_HUMAN_LEANING"}},
			{label = "Opieranie się", keyword = "opieranie", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", mode = 1}},
			{label = "Opieranie się v2", keyword = "opieranie2", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@hands_together@base", anim = "base", mode = 1}},
			{label = "Opieranie się v3", keyword = "opieranie3", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@foot_up@base", anim = "base", mode = 1}},
			{label = "Opieranie się na ramionach", keyword = "opieranie4", type = "anim", data = {lib = "missstrip_club_lean", anim = "player_lean_rail_loop", mode = 1}},
			{label = "Opieranie się na rękach", keyword = "opieranie5", type = "anim", data = {lib = "mp_safehousebeer@", anim = "base_drink", mode = 1}},
			{label = "Opieranie się do tyłu", keyword = "opieranie6", type = "anim", data = {lib = "anim@amb@nightclub@gt_idle@", anim = "base", mode = 1}},
			{label = "Opieranie na ramieniu", keyword = "opieranie8", type = "anim", data = {lib = "rcmjosh2", anim = "josh_2_intp1_base", mode = 17}},
			{label = "Opieranie na ramieniu v2", keyword = "opieranie9", type = "anim", data = {lib = "timetable@mime@01_gc", anim = "idle_a", mode = 1}},
			{label = "Kucnięcie z podparciem", keyword = "zpodparciem", type = "anim", data = {lib = "misscarstealfinalecar_5_ig_3", anim = "crouchloop", mode = 1}},
			{label = "Leżenie na plecach", keyword = "lezenie", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
			{label = "Leżenie na plecach v2", keyword = "lezenie2", type = "anim", data = {lib = "timetable@tracy@sleep@", anim = "idle_c", mode = 1}},
			{label = "Leżenie na brzuchu", keyword = "lezenie3", type = "anim", data = {lib = "amb@world_human_sunbathe@male@front@base", anim = "base", mode = 1}},
			{label = "Leżenie na brzuchu v2", keyword = "lezenie4", type = "anim", data = {lib = "amb@world_human_sunbathe@female@front@base", anim = "base", mode = 1}},
			{label = "Leżenie na boku", keyword = "lezenie5", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_left_side@base", anim = "base", mode = 1}},
			{label = "Leżenie na boku v2", keyword = "lezenie6", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@lo_sofa@", anim = "lowsofa_dlg_fuckedup_laz", mode = 1}},
			{label = "Leżenie na kanapie", keyword = "lezenie7", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "laying", mode = 1}},
			{label = "Kładzenie się do łóżka", keyword = "kladzenie", type = "anim", data = {lib = "mp_bedmid", anim = "f_getin_l_bighouse"}},
			{label = "Siedzenie z telefonem", keyword = "siedzenie", type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle", mode = 1}},
			{label = "Siedzenie na ziemii na luzaku", keyword = "siedzenie", type = "anim", data = {lib = "anim@heists@fleeca_bank@ig_7_jetski_owner", anim = "owner_idle", mode = 1}},
			{label = "Siedzenie na ziemii na luzaku v2", keyword = "siedzenie2", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "idle_a_jimmy", mode = 1}},
			{label = "Siedzenie na ziemii w zwarciu", keyword = "siedzenie3", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "sit_phone_phoneputdown_fallasleep_nowork", mode = 1}},
			{label = "Siedzenie na ziemii przygnębiony", keyword = "siedzenie4", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "sit_phone_phoneputdown_sleeping-noworkfemale", mode = 1}},
			{label = "Siedzenie po turecku z rękami w górze", keyword = "siedzenie3", type = "anim", data = {lib = "mp_fm_intro_cut", anim = "base_loop", mode = 1}},
			{label = "Siedzenie pod ścianą", keyword = "siedzenie6", type = "anim", data = {lib = "amb@world_human_stupor@male@idle_a", anim = "idle_b", mode = 1}},
			{label = "Siedzenie na ziemi załamany", keyword = "siedzenie7", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@lo_alone@", anim = "lowalone_dlg_longrant_laz", mode = 1}}
		}
	},

	{
		name  = 'situational',
		label = 'Sytuacyjne',
		items = {
			{label = "Selfie", keyword = "selfie", type = "scenario", data = {anim = "WORLD_HUMAN_TOURIST_MOBILE"}},
			{label = "Ręce za glowe", keyword = "rece", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c", mode = 49}},
			{label = "Strach", keyword = "strach", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
			{label = "Zakładnik", keyword = "zakladnik", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c", mode = 1}},
			{label = "Zakładnik z podniesionymi rękami", keyword = "zakladnik2", type = "anim", data = {lib = "random@getawaydriver", anim = "idle_a", mode = 1}},
			{label = "Chowanie się", keyword = "chowanie", type = "anim", data = {lib = "mp_am_hold_up", anim = "cower_loop"}},
			{label = "Rozpacz", keyword = "rozpacz", type = "anim", data = {lib = "mp_bank_heist_1", anim = "f_cower_01"}},
			{label = "Poddanie się na glebe", keyword = "poddanie", type = "anim", data = {lib = "mp_bank_heist_1", anim = "prone_l_front_intro", mode = 2}},
			{label = "Rozgladanie się", keyword = "rozgladanie", type = "scenario", data = {anim = "CODE_HUMAN_CROSS_ROAD_WAIT"}},
			{label = "Rozgladanie się v2", keyword = "rozgladanie2", type = "anim", data = {lib = "mp_fm_intro_cut", anim = "idle_a"}},
			{label = "Wkurzenie się", keyword = "wkurzenie", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@freakout", anim = "freakout"}},
			{label = "Wymiotowanie w aucie", keyword = "wymiotuj", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside", car = true}},
			{label = "Kibicowanie", keyword = "kibicowanie", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_b", mode = 1}},
			{label = "Kibicowanie v2", keyword = "kibicowanie2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_a_player_a", mode = 1}},
			{label = "Ręce do tyłu", keyword = "rece2", type = "anim", data = {lib = "anim@miss@low@fin@vagos@", anim = "idle_ped06", mode = 49}},
			{label = "Drapanie się po tyłku", keyword = "drapanie", type = "anim", data = {lib = "anim@heists@team_respawn@respawn_01", anim = "heist_spawn_01_ped_d", mode = 49}},
			{label = "Otrzepanie się", keyword = "otrzepanie", type = "anim", data = {lib = "move_m@_idles@shake_off", anim = "shakeoff_1"}},
			{label = "Otrzepanie się v2", keyword = "otrzepanie2", type = "anim", data = {lib = "move_m@_idles@wet", anim = "fidget_wet"}},
			{label = "Sprawdzanie wody pod prysznicem", keyword = "woda", type = "anim", data = {lib = "mp_safehouseshower@female@", anim = "shower_enter_into_idle"}},
			{label = "Mycie się", keyword = "mycie", type = "anim", data = {lib = "mp_safehouseshower@female@", anim = "shower_idle_a"}},
			{label = "Mycie się v2", keyword = "mycie2", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_a"}},
			{label = "Oczekiwanie", keyword = "oczekiwanie", type = "anim", data = {lib = "rcmjosh1leadinout", anim = "idle_josh"}},
			{label = "Czytanie", keyword = "czytanie", type = "anim", data = {lib = "misscarsteal4@vendor", anim = "base_customer1", mode = 1}},
			{label = "Kac", keyword = "kac", type = "anim", data = {lib = "random@peyote@generic", anim = "wakeup"}},
			{label = "Celowanie", keyword = "celowanie", type = "anim", data = {lib = "random@countryside_gang_fight", anim = "biker_02_stickup_loop", mode = 49}},
			{label = "Celowanie w bok", keyword = "celowanie2", type = "anim", data = {lib = "random@atmrobberygen", anim = "b_atm_mugging", mode = 49}},
		}
	},

	{
		name  = 'festives',
		label = 'Imprezka',
		items = {
			{label = "Bujanie się", keyword = "bujanie", type = "scenario", data = {anim = "WORLD_HUMAN_STRIP_WATCH_STAND"}}, -- todo
			{label = "Granie na instrumentach", keyword = "granie", type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}}, -- todo
			{label = "DJ", keyword = "dj", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
			{label = "Picie kawy w miejscu", keyword = "kawa", type = "loop", data = {base = {lib = "amb@world_human_aa_coffee@base", anim = "base", length = 3600}, idle = {lib = "amb@world_human_aa_coffee@idle_a", anims = {{"idle_a", 6200}, {"idle_b", 3700}, {"idle_c", 6500}}}, finish = {lib = "amb@world_human_aa_coffee@base", anim = "base", length = 4500}, mode = 0, prop = {object = "p_ing_coffeecup_01", bone = 57005, offset = {x = 0.125, y = 0.02, z = -0.03}, rotation = {x = 95.0, y = 140.0, z = 190.0}, dettach = true}}},
			{label = "Picie kawy", keyword = "kawa2", type = "anim", data = {lib = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", mode = 49, prop = {object = "p_ing_coffeecup_01", bone = 57005, offset = {x = 0.125, y = 0.02, z = -0.03}, rotation = {x = 95.0, y = 140.0, z = 190.0}}}},
			{label = "Rock'n'roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
			{label = "Robienie grilla", keyword = "grill", type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}}, -- todo
			{label = "Wciąganie mety", keyword = "meta", type = "anim", data = {lib = "anim@amb@nightclub@peds@", anim = "missfbi3_party_snort_coke_b_male3", mode = 1}},
			{label = "Z gleby", keyword = "zgleby", type = "anim", data = {lib = "random@peyote@eat", anim = "eat_peyote"}},
			{label = "Kacuwa", keyword = "kacuwa", type = "anim", data = {lib = "random@peyote@generic", anim = "wakeup"}},
			{label = "Wydurnianie", keyword = "wydurnianie", type = "anim", data = {lib = "timetable@tracy@ig_5@idle_a", anim = "idle_c"}},
			{label = "Wydurnianie v2", keyword = "wydurnianie2", type = "anim", data = {lib = "timetable@tracy@ig_5@idle_b", anim = "idle_d"}}
		}
	},

	{
		name  = 'work',
		label = 'Praca',
		items = {
			{label = "Przygotowanie broni", keyword = "bron", type = "anim", data = {lib = "mp_corona@single_team", anim = "single_team_intro_one"}},
			{label = "Robienie zdjęć", keyword = "foto", type = "loop",  data = {base = {lib = "amb@world_human_paparazzi@male@enter", anim = "enter", length = 1000}, idle = {lib = "amb@world_human_paparazzi@male@idle_a", anims = {{"idle_a", 6000}, {"idle_b", 6000}, {"idle_c", 5000}}}, finish = {lib = "amb@world_human_paparazzi@male@exit", anim = "exit", length = 1000}, mode = 0, prop = {object = "prop_pap_camera_01", bone = 58866, offset = {x = 0.1, y = -0.05, z = 0.0}, rotation = {x = -10.0, y = 50.0, z = 5.0}, dettach = false}}},
			{label = "Żebrak", keyword = "zebrak", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}}, -- todo
			{label = "Pakowanie na naczepę", keyword = "pakowanie", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
			{label = "Kierowanie ruchem", keyword = "kierowanie", type = "anim", data = {lib = "amb@world_human_car_park_attendant@male@base", anim = "base", mode = 1, prop = {bone = 57005, object = "prop_parking_wand_01", offset = {x = 0.1, y = 0.0, z = -0.03}, rotation = {x = -60.0, y = 0.0, z = 0.0}}}},
			{label = "Wędkowanie", keyword = "wedkowanie", type = "scenario", data = {anim = "WORLD_HUMAN_STAND_FISHING"}},
			{label = "Podsłuchiwanie", keyword = "podsluch", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}},
			{label = "Szukanie śladów", keyword = "szukanie", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
			{label = "Kopanie w ogródku", keyword = "kopanie", type = "scenario", data = {anim = "WORLD_HUMAN_GARDENER_PLANT"}},
			{label = "Kopanie łopatą", keyword = "kopanie2", type = "anim", data = {lib = "random@burial", anim = "a_burial", mode = 1, prop = {bone = 28422, object = "prop_ld_shovel", offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}}}},
			{label = "Pisanie na klawiaturze", keyword = "klawiatura", type = "anim", data = {lib = "missah_2_ext_altleadinout", anim = "hack_loop", mode = 1}},
			{label = "Sprawdzanie notatek", keyword = "notatki", type = "anim", data = {lib = "amb@world_human_clipboard@male@idle_a", anim = "idle_c", mode = 49, prop = {bone = 36029, object = "p_amb_clipboard_01", offset = {x = 0.1, y = 0.015, z = 0.12}, rotation = {x = -120.0, y = -60.0, z = 0.0}}}},
			{label = "Młotek", keyword = "mlotek", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
			{label = "Mycie okna", keyword = "mycieokna", type = "scenario", data = {anim = "WORLD_HUMAN_MAID_CLEAN"}},
			{label = "Mim", keyword = "mim", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
			{label = "Mycie blatu", keyword = "mycieblatu", type = "anim", data = {lib = "timetable@floyd@clean_kitchen@base", anim = "base", mode = 1}},
			{label = "Wymiana żarówki", keyword = "zarowka", type = "anim", data = {lib = "amb@prop_human_movie_bulb@base", anim = "base", mode = 1}},
			{label = "Mechanik", keyword = "mechanik", type = "anim", data = {lib = "amb@world_human_vehicle_mechanic@male@base", anim = "base", mode = 1}},
			{label = "Mechanik 2", keyword = "mechanik2", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped", mode = 1}},
			{label = "Mechanik 3", keyword = "mechanik3", type = "anim", data = {lib = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", mode = 1}},
			{label = "Mechanik 4", keyword = "mechanik4", type = "anim", data = {lib = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", anim = "machinic_loop_mechandplayer", mode = 51}},
			{label = "Wiercenie wiertarką", keyword = "wiertarka", type = "anim", data = {lib = "anim@heists@fleeca_bank@drilling", anim = "drill_straight_start", mode = 1, prop = {bone = 57005, object = "prop_tool_drill", offset = {x = 0.1, y = 0.04, z = -0.03}, rotation = {x = -90.0, y = 180.0, z = 0.0}}}},
		}
	},

	{
		name  = 'humors',
		label = 'Humor',
		items = {
			{label = "Kajdanki", keyword = "kajdanki", type = "anim", data = {lib = "mp_arresting", anim = "idle", mode = 49}},
			{label = "Klaskanie", keyword = "klaskanie", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
			{label = "Facepalm", keyword = "facepalm", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
			{label = "Samobójstwo", keyword = "ck", type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
			{label = "Skok w bok", type = "anim", data = {lib = "melee@unarmed@streamed_core_psycho", anim = "victim_psycho_rear_takedown"}},
			{label = "Jezus", keyword = "jezus", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
			{label = "Palec w dziurke", keyword = "palec", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@dock", anim = "dock"}},	
			{label = "Jesteś pierdolnięty", keyword = "pierdolniety", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@you_loco", anim = "you_loco"}},
			{label = "Jaskółka", keyword = "jaskolka", type = "anim", data = {lib = "random@peyote@bird", anim = "wakeup"}},
			{label = "Kurczak", keyword = "kurczak", type = "anim", data = {lib = "random@peyote@chicken", anim = "wakeup"}},
			{label = "Cztery łapy", keyword = "4lapy", type = "anim", data = {lib = "random@peyote@deer", anim = "wakeup"}},
			{label = "Pies", keyword = "pies", type = "anim", data = {lib = "random@peyote@dog", anim = "wakeup"}}
		}
	},

	{
		name  = 'sports',
		label = 'Sport',
		items = {
			{label = "Garda", keyword = "garda", type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
			{label = "Rozgrzewka", keyword = "rozgrzewka", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
			{label = "Bitka", keyword = "bitka", type = "anim", data = {lib = "mp_deathmatch_intros@unarmed", anim = "intro_male_unarmed_b"}},
			{label = "Jogging", keyword = "jogging", type = "scenario", data = {anim = "WORLD_HUMAN_JOG_STANDING"}},
			{label = "Pompki", keyword = "pompki", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base", mode = 1}},
			{label = "Brzuszki", keyword = "brzuszki", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base", mode = 1}},
			{label = "Napinanie", keyword = "napinanie1", type = "scenario", data = {anim = "WORLD_HUMAN_MUSCLE_FLEX"}},
			{label = "Napinanie mięśni", keyword = "napinanie2", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
			{label = "Napinanie bicków", keyword = "napinanie3", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_in_front@idle_a", anim = "idle_a"}},
			{label = "Trenowanie bicków", keyword = "bicki", type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
			{label = "Yoga", keyword = "yoga", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
			{label = "Salto w tył", keyword = "salto", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "flip_a_player_a"}},
			{label = "Gwiazda", keyword = "gwiazda", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "cap_a_player_a"}},
			{label = "Rozciąganie", keyword = "rozciaganie", type = "anim", data = {lib = "rcmfanatic1maryann_stretchidle_b", anim = "idle_e"}},
			{label = "Pajacyki", keyword = "pajacyki", type = "anim", data = {lib = "timetable@reunited@ig_2", anim = "jimmy_masterbation"}}
		}
	},

	{
		name  = 'dances',
		label = 'Taniec',
		items = {
			{label = "Taniec", keyword = "taniec", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_06_base_laz", mode = 1}},
			{label = "Taniec konia", keyword = "kon", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_dancefloor@", anim = "dancecrowd_li_11_hu_shimmy_laz", mode = 1, prop = {bone = 28422, object = "ba_prop_battle_hobby_horse", offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}}}},			
			{label = "Taniec konia 2", keyword = "kon2", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_dancefloor@", anim = "dancecrowd_li_15_handup_laz", mode = 51, prop = {bone = 28422, object = "ba_prop_battle_hobby_horse", offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}}}},			
			{label = "Taniec z Glowstickiem", keyword = "glowstick", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_railing@", anim = "ambclub_09_mi_hi_bellydancer_laz", mode = 1, prop = {bone = 28422, object = "ba_prop_battle_glowstick_01", offset = {x = 0.07, y = 0.14, z = 0.0}, rotation = {x = -80.0, y = 20.0, z = 0.0}}}},
			{label = "Taniec z Glowstickiem 2", keyword = "glowstick2", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_railing@", anim = "ambclub_09_mi_hi_bellydancer_laz", mode = 1, prop = {bone = 60309, object = "ba_prop_battle_glowstick_01", offset = {x = 0.07, y = 0.09, z = 0.0}, rotation = {x = -120.0, y = -20.0, z = 0.0}}}},
			{label = "Taniec z Glowstickiem 3", keyword = "glowstick3", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_railing@", anim = "ambclub_12_mi_hi_bootyshake_laz", mode = 51, prop = {bone = 60309, object = "ba_prop_battle_glowstick_01", offset = {x = 0.07, y = 0.09, z = 0.0}, rotation = {x = -120.0, y = -20.0, z = 0.0}}}},
			{label = "Disco", keyword = "disco", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@uncle_disco", anim = "uncle_disco", mode = 1}},
			{label = "Impra", keyword = "impra", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^3", mode = 1}},
			{label = "Wczuta", keyword = "wczuta", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^6", mode = 1}},
			{label = "Zabawa", keyword = "zabawa", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1", mode = 1}},
			{label = "Krec tym mała", keyword = "krec", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_17_smackthat_laz", mode = 1}},
			{label = "Densjer", keyword = "densjer", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^3", mode = 1}},
			{label = "Robot", keyword = "robot", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_15_robot_laz", mode = 1}},
			{label = "Wixa", keyword = "wixa", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel", mode = 1}},
			{label = "Stepowanie", keyword = "stepowanie", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", mode = 1}},
			{label = "Boogie", keyword = "boogie", type = "anim", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_loop_tyler", mode = 1}},
			{label = "Striptizerka", keyword = "striptizerka", type = "anim", data = {lib = "mp_am_stripper", anim = "lap_dance_girl", mode = 1}},
			{label = "Macarena", keyword = "macarena", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", mode = 1}},
			{label = "Taniec kurczaka", keyword = "kurczak", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@chicken_taunt", anim = "chicken_taunt", mode = 1}},
			{label = "Taniec losia", keyword = "los", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@thumb_on_ears", anim = "thumb_on_ears", mode = 1}},
			{label = "Taniec spidermana", keyword = "spiderman", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_17_spiderman_laz", mode = 1}},
			{label = "Wywijanie reka", keyword = "wywijanie", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@find_the_fish", anim = "find_the_fish", mode = 1}},
			{label = "Imprezka", keyword = "impra1", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^3", mode = 1}},
			{label = "Wczuta 1", keyword = "wczuta1", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^6", mode = 1}},
			{label = "Wczuta 2", keyword = "wczuta2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^1", mode = 1}},
			{label = "Wczuta 3", keyword = "wczuta3", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center", mode = 1}},
			{label = "Połamaniec 1", keyword = "polamaniec1", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1", mode = 1}},
			{label = "Połamaniec 2", keyword = "polamaniec2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3", mode = 1}},
			{label = "Połamaniec 3", keyword = "polamaniec3", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6", mode = 1}},
			{label = "Węgorz", keyword = "wegorz", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^1", mode = 1}},
			{label = "Zabawa 1", keyword = "zabawa", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1", mode = 1}},
			{label = "Zabawa 2", keyword = "zabawa2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^3", mode = 1}},
			{label = "Szejker", keyword = "densjer", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^3", mode = 1}},
			{label = "Vixa 1", keyword = "wixa1", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel", mode = 1}},
			{label = "Vixa 2", keyword = "wixa2", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_turnaround_laz", mode = 1}},
			{label = "Imprezowa 1", keyword = "imprezowa1", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1", mode = 1}},
			{label = "Imprezowa 2", keyword = "imprezowa2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2", mode = 1}},
			{label = "Imprezowa 3", keyword = "imprezowa3", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3", mode = 1}},			
			{label = "Imprezowa 4", keyword = "imprezowa4", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_17_crotchgrab_laz", mode = 1}},
			{label = "Twerk", keyword = "twerk", type = "anim", data = {lib = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_idle_stripper", mode = 1}}

		}
	},
	{
		name  = 'dances2',
		label = '40 Tańców',
		items = {	
        {label = "Taniec 1", type = "anim", keyword = "taniec1", data = {lib = "anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity", anim = "mi-hi_amb_club_10_v1_male^6", mode = 1}},
        {label = "Taniec 2", type = "anim", keyword = "taniec2", data = {lib = "amb@code_human_in_car_mp_actions@dance@bodhi@ds@base", anim = "idle_a_fp", mode = 1}},
        {label = "Taniec 3", type = "anim", keyword = "taniec3", data = {lib = "amb@code_human_in_car_mp_actions@dance@bodhi@rds@base", anim = "idle_b", mode = 1}},
        {label = "Taniec 4", type = "anim", keyword = "taniec4", data = {lib = "amb@code_human_in_car_mp_actions@dance@std@ds@base", anim = "idle_a", mode = 1}},
        {label = "Taniec 5", type = "anim", keyword = "taniec5", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^6", mode = 1}},
        {label = "Taniec 6", type = "anim", keyword = "taniec6", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^6", mode = 1}},
        {label = "Taniec 7", type = "anim", keyword = "taniec7", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^6", mode = 1}},
        {label = "Taniec 8", type = "anim", keyword = "taniec8", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^6", mode = 1}},
        {label = "Taniec 9", type = "anim", keyword = "taniec9", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^6", mode = 1}},
        {label = "Taniec 10", type = "anim", keyword = "taniec10", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^6", mode = 1}},
        {label = "Taniec 11", type = "anim", keyword = "taniec11", data = {lib = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^6", mode = 1}},
        {label = "Taniec 12", type = "anim", keyword = "taniec12", data = {lib = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^6", mode = 1}},
        {label = "Taniec 13", type = "anim", keyword = "taniec13", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_center_up", mode = 1}},
        {label = "Taniec 14", type = "anim", keyword = "taniec14", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", anim = "med_right_up", mode = 1}},
        {label = "Taniec 15", type = "anim", keyword = "taniec15", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^6", mode = 1}},
        {label = "Taniec 16", type = "anim", keyword = "taniec16", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^6", mode = 1}},
        {label = "Taniec 17", type = "anim", keyword = "taniec17", data = {lib = "timetable@tracy@ig_5@idle_b", anim = "idle_e", mode = 1}},
        {label = "Taniec 18", type = "anim", keyword = "taniec18", data = {lib = "mini@strip_club@idles@dj@idle_04", anim = "idle_04", mode = 1}},
        {label = "Taniec 19", type = "anim", keyword = "taniec19", data = {lib = "special_ped@mountain_dancer@monologue_1@monologue_1a", anim = "mtn_dnc_if_you_want_to_get_to_heaven", mode = 1}},
        {label = "Taniec 20", type = "anim", keyword = "taniec20", data = {lib = "special_ped@mountain_dancer@monologue_4@monologue_4a", anim = "mnt_dnc_verse", mode = 1}},
        {label = "Taniec 21", type = "anim", keyword = "taniec21", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", mode = 1}},
        {label = "Taniec 22", type = "anim", keyword = "taniec22", data = {lib = "anim@amb@nightclub@dancers@black_madonna_entourage@", anim = "hi_dance_facedj_09_v2_male^5", mode = 1}},
        {label = "Taniec 23", type = "anim", keyword = "taniec23", data = {lib = "anim@amb@nightclub@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^6", mode = 1}},
        {label = "Taniec 24", type = "anim", keyword = "taniec24", data = {lib = "anim@amb@nightclub@dancers@dixon_entourage@", anim = "mi_dance_facedj_15_v1_male^4", mode = 1}},
        {label = "Taniec 25", type = "anim", keyword = "taniec25", data = {lib = "anim@amb@nightclub@dancers@podium_dancers@", anim = "hi_dance_facedj_17_v2_male^5", mode = 1}},
        {label = "Taniec 26", type = "anim", keyword = "taniec26", data = {lib = "anim@amb@nightclub@dancers@tale_of_us_entourage@", anim = "mi_dance_prop_13_v2_male^4", mode = 1}},
        {label = "Taniec 27", type = "anim", keyword = "taniec27", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", mode = 1}},
        {label = "Taniec 28", type = "anim", keyword = "taniec28", data = {lib = "misschinese2_crystalmazemcs1_ig", anim = "dance_loop_tao", mode = 1}},
        {label = "Taniec 29", type = "anim", keyword = "taniec29", data = {lib = "anim@mp_player_intcelebrationfemale@uncle_disco", anim = "uncle_disco", mode = 1}},
        {label = "Taniec 30", type = "anim", keyword = "taniec30", data = {lib = "anim@mp_player_intcelebrationfemale@raise_the_roof", anim = "raise_the_roof", mode = 1}},
        {label = "Taniec 31", type = "anim", keyword = "taniec31", data = {lib = "anim@mp_player_intcelebrationmale@cats_cradle", anim = "cats_cradle", mode = 1}},
        {label = "Taniec 32", type = "anim", keyword = "taniec32", data = {lib = "anim@mp_player_intupperbanging_tunes", anim = "idle_a", mode = 1}},
        {label = "Taniec 33", type = "anim", keyword = "taniec33", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center", mode = 1}},
        {label = "Taniec 34", type = "anim", keyword = "taniec34", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center", mode = 1}},
        {label = "Taniec 35", type = "anim", keyword = "taniec35", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", anim = "high_center", mode = 1}},
        {label = "Taniec 36", type = "anim", keyword = "taniec36", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^6", mode = 1}},
        {label = "Taniec 37", type = "anim", keyword = "taniec37", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^6", mode = 1}},
        {label = "Taniec 38", type = "anim", keyword = "taniec38", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^6", mode = 1}},
        {label = "Taniec 39", type = "anim", keyword = "taniec39", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^6", mode = 1}},
        {label = "Taniec 40", type = "anim", keyword = "taniec40", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_06_base_laz", mode = 1}},
		
		}
	},
	
	{
		name  = 'movements',
		label = 'Style chodzenia',
		items = {
			{label = "Codzienny", type = "attitude", keyword = "codzienny", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
			{label = "Kozak", type = "attitude", keyword = "kozak", data = {lib = "MOVE_M@TOUGH_GUY@", anim = "MOVE_M@TOUGH_GUY@"}},
			{label = "Jogging", type = "anim", keyword = "jogging", data = {lib = "move_f@jogger", anim = "idle", mode = 49}},
			{label = "Normalne (M)", type = "attitude", keyword = "normalneM", data = {lib = "move_m@confident", anim = "move_m@confident"}},
			{label = "Normalne (K)", type = "attitude", keyword = "normalneK", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
			{label = "Depresja (M)", type = "attitude", keyword = "depresjaM", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
			{label = "Depresja (K)", type = "attitude", keyword = "depresjaK", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
			{label = "Biznesman", type = "attitude", keyword = "biznesmen", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
			{label = "Zdeterminowany", type = "attitude", keyword = "zdeterminowany", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
			{label = "Grubas", type = "attitude", keyword = "grubas", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
			{label = "Hipster", type = "attitude", keyword = "hipster", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
			{label = "Kulawy", type = "attitude", keyword = "kulawy", data = {lib = "move_m@injured", anim = "move_m@injured"}},
			{label = "Wkurwiony", type = "attitude", keyword = "wkurwiony", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
			{label = "Włóczęga", type = "attitude", keyword = "wloczega", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
			{label = "Smutny", type = "attitude", keyword = "smutny", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
			{label = "Muskularny", type = "attitude", keyword = "muskularny", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
			{label = "Mroczny", type = "attitude", keyword = "mroczny", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
			{label = "Zmęczony", type = "attitude", keyword = "zmeczony", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
			{label = "Szybki krok", type = "attitude", keyword = "szybkikrok", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
			{label = "Dumny", type = "attitude", keyword = "dumny", data = {lib = "move_m@money", anim = "move_m@money"}},
			{label = "Wyścig", type = "attitude", keyword = "wyscig", data = {lib = "move_m@quick", anim = "move_m@quick"}},
			{label = "Ciepły", type = "attitude", keyword = "cieply", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
			{label = "Ciepły v2", type = "attitude", keyword = "cieply2", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
			{label = "Arogancki", type = "attitude", keyword = "arogancki", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
			{label = "Gangster", type = "attitude", keyword = "gangster", data = {lib = "move_m@gangster@generic", anim = "move_m@gangster@generic"}},
			{label = "Gangster 2", type = "attitude", keyword = "gangster2", data = {lib = "move_m@gangster@ng", anim = "move_m@gangster@ng"}},
			{label = "Swagger", type = "attitude", keyword = "swagger", data = {lib = "move_m@swagger", anim = "move_m@swagger"}},
			{label = "Pewny siebie", type = "attitude", keyword = "pewnysiebie", data = {lib = "move_m@fire", anim = "move_m@fire"}}
		}
	},

	{
		name = 'speaking',
		label = 'Style mówienia',
		items = {
			{label = "Normalny", type = "facial", data = 1, keyword = "normalny2"},
			{label = "Wkurwiony", type = "facial", data = 2, keyword = "wkurwiony2"},
			{label = "Zaangażowany", type = "facial", data = 3, keyword = "zaangazowany"},
			{label = "Skupiony", type = "facial", data = 4, keyword = "skupiony"},
			{label = "Zły", type = "facial", data = 5, keyword = "zly"},
			{label = "Zacieszony", type = "facial", data = 6, keyword = "zacieszony"},
			{label = "Szczęśliwy", type = "facial", data = 7, keyword = "szczesliwy"},
			{label = "Zdziwiony", type = "facial", data = 8, keyword = "zdziwiony"},
			{label = "Zamknięte oczy", type = "facial", data = 9, keyword = "zamknieteoczy"},
			{label = "Odczuwając ból", type = "facial", data = 10, keyword = "odczuwajacybol"}
		}
	},
	
	{
		name = 'objects',
		label = 'Operowanie obiektami',
		items = {
			{label = "Skrzynia z narzędziami", type = "anim", keyword = "skrzynka", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", mode = 49, prop = {bone = 57005, object = "prop_tool_box_04", offset = {x = 0.43, y = 0.0, z = -0.02}, rotation = {x = -90.0, y = 0.0, z = 90.0}}}},
			{label = "Skrzynka z wiertarką", type = "anim", keyword = "skrzynka2", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", mode = 49, prop = {bone = 57005, object = "prop_tool_box_02", offset = {x = 0.53, y = 0.0, z = -0.02}, rotation = {x = -90.0, y = 0.0, z = 90.0}}}},
			{label = "Paczka", type = "anim", keyword = "paczka", data = {lib = "anim@heists@box_carry@", anim = "idle", mode = 49, prop = {bone = 28422, object = "v_serv_abox_04", offset = {x = 0.0, y = -0.08, z = -0.17}, rotation = {x = 0.0, y = 0.0, z = 90.0}}}},
			{label = "Aktówka", type = "anim", keyword = "aktowka", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", mode = 49, prop = {bone = 57005, object = "prop_ld_case_01", offset = {x = 0.13, y = 0.0, z = -0.02}, rotation = {x = -90.0, y = 0.0, z = 90.0}}}},
			{label = "Walizka", type = "anim", keyword = "walizka", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", mode = 49, prop = {bone = 57005, object = "hei_p_attache_case_shut", offset = {x = 0.13, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = -90.0}}}},
			{label = "Walizka podróżna", type = "anim", keyword = "walizka2", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", mode = 49, prop = {bone = 57005, object = "prop_ld_suitcase_01", offset = {x = 0.36, y = 0.0, z = -0.02}, rotation = {x = -90.0, y = 0.0, z = 90.0}}}},
			{label = "Walizka na kółkach", type = "anim", keyword = "walizka3", data = {lib = "anim@heists@narcotics@trash", anim = "walk", mode = 49, prop = {bone = 57005, object = "prop_suitcase_03", offset = {x = 0.36, y = -0.45, z = -0.05}, rotation = {x = -50.0, y = -60.0, z = 15.0}}}}
		}
	},

	{
		name  = 'porn',
		label = 'PEGI 21',
		items = {
			{label = "Masturbacja", keyword = "masturbacja1", type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01", mode = 49}},
			{label = "Masturbacja z wytryskiem", keyword = "masturbacja2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@wank", anim = "wank"}},
			{label = "Pomaganie pani w aucie", keyword = "waucie1", type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop", car = true}},
			{label = "Robienie loda w aucie", keyword = "waucie2", type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop", car = true}},
			{label = "Seks w aucie", keyword = "waucie3", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player", car = true}},
			{label = "Siadanie w aucie", keyword = "waucie4", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female", car = true}},
			{label = "Drapanie się po jajach", keyword = "drapanie", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
			{label = "Kobiecy urok", keyword = "urok", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
			{label = "Posuwanie", keyword = "posuwanie", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
			{label = "Posuwanie v2", keyword = "posuwanie2", type = "anim", data = {lib = "timetable@trevor@skull_loving_bear", anim = "skull_loving_bear", mode = 1}},			
			{label = "Wypięcie tyłka", keyword = "wypinanie", type = "anim", data = {lib = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_exit_trv"}},
			{label = "Czekająca pani", keyword = "czekajaca", type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
			{label = "Wystawianie tyłka i piersi", keyword = "wystawianie", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
			{label = "Zaproszenie faceta", keyword = "zaproszenie", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_invite", anim = "ld_girl_a_invite"}},
			{label = "Striptiz taniec v1", keyword = "striptiz1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
			{label = "Striptiz taniec v2", keyword = "striptiz2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
			{label = "Striptiz taniec v3", keyword = "striptiz3", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
			{label = "Striptiz taniec v4", keyword = "striptiz4", type = "anim", data = {lib = "mini@strip_club@private_dance@part1", anim = "priv_dance_p1"}}
		}
	}
}
Config.Gesty = {
	handsUp = Keys["~"],
	pointing = Keys["B"],
	kabura = Keys["LEFTALT"],
	crosshands = Keys["G"]
}

Ped = {
	Active = false,
	Locked = false,
	Id = 0,
	Alive = false,
	Available = false,
	Visible = false,
	InVehicle = false,
	OnFoot = false,
	Collection = false
}

CreateThread(function()
	while true do
		Citizen.Wait(200)

		Ped.Active = not IsPauseMenuActive()
		if Ped.Active then
			Ped.Id = PlayerPedId()
			if not IsEntityDead(Ped.Id) then
				Ped.Locked = (exports['IslandRP']:checkInTrunk() or exports['esx_policejob']:isHandcuffed() or getCarry())
				Ped.Alive = true
				Ped.Available = (Ped.Alive and not Ped.Locked)
				Ped.Visible = IsEntityVisible(Ped.Id)
				Ped.InVehicle = IsPedInAnyVehicle(Ped.Id, false)
				Ped.OnFoot = IsPedOnFoot(Ped.Id)

				if Ped.Available and not Ped.InVehicle and Ped.Visible then
					Ped.Collection = not IsPedFalling(Ped.Id) and not IsPedDiving(Ped.Id) and not IsPedSwimming(Ped.Id) and not IsPedSwimmingUnderWater(Ped.Id) and not IsPedInCover(Ped.Id, false) and not IsPedInParachuteFreeFall(Ped.Id) and (GetPedParachuteState(Ped.Id) == 0 or GetPedParachuteState(Ped.Id) == -1) and not IsPedBeingStunned(Ped.Id)
				else
					Ped.Collection = false
				end
			else
				Ped.Alive = false
				Ped.Available = false
				Ped.Visible = IsEntityVisible(Ped.Id)
				Ped.InVehicle = false
				Ped.OnFoot = true
				Ped.Collection = false
			end
		end
	end
end)

function PedStatus()
	return Ped.Collection
end