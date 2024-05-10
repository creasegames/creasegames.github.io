GDPC                �                                                                         P   res://.godot/exported/133200997/export-609f762188a68253d349ec58c4f3a8d3-game.scn�      y      F�[\#�;���MH݁    T   res://.godot/exported/133200997/export-98ed4b6f6e0850185d15724f9bda0923-fishy.scn   �      �      �RvE�ߖ��Gq�4�n    ,   res://.godot/global_script_class_cache.cfg  1             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex@"            ：Qt�E�cO���       res://.godot/uid_cache.bin  �4      U       ��L旰�����Ѽ�5       res://boatmove.gd           O      ��μA�AT
a��e�       res://fishy.gd  P      !      Wɱ����A�Pn��,       res://fishy.tscn.remap  00      b       UnM}C���.&�"�u�;       res://fishybar.gd         j      ��N�;VH0V-�|��       res://game.gd   �      1      f�`�=g�]�).��Ѫ       res://game.tscn.remap   �0      a       �?��� �ު��y�       res://icon.svg  01      �      k����X3Y���f       res://icon.svg.import   `/      �       ��StX����}�{Y��       res://project.binaryP5      �      �5��p:���̧�            extends CharacterBody2D

var speedmax = 300
var speed = Vector2.ZERO
var canmove = true

func _physics_process(delta):
	if speed.length()>200:
		speed.normalized()*200
	# Handle jump.
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canmove:
		speed += (get_global_mouse_position()-position).normalized()*5
	elif speed:
		speed -= speed.normalized()*2.5
		if speed.length()<5:
			speed = Vector2.ZERO
	if speed.length()>200:
		speed=speed.normalized()*200
	
	velocity=speed
	
		
	#print(speed.length())

	move_and_slide()


func _on_yippeetimer_timeout():
	$yippeefish.visible=false
 extends Area2D

var lined = false
var fishtype = []

func _ready():
	$Timer.wait_time=randi_range(3,6)
	var fishes = [
		["cod", 72, 24, 72],
		["tuna", 144, 136, 104],
		["salmon", 80, 40, 8, 16],
		["mackerel", 72,96,104],
		["flounder 2.0", 28, 20, 64, 8],
		["treasure map", 8, 16, 24, 32, 40, 48, 56, 64, 72, 80]
	]
	fishtype=fishes.pick_random()


func _on_timer_timeout():
	if !lined:
		queue_free()


func _on_button_pressed():
	if abs(get_node("../boat").position.length()-position.length())<=128:
		lined = true
		get_parent().canfish=false
		get_node("../boat").canmove=false
		get_node("../fishybar").set_process(true)
		get_node("../fishybar").visible=true
		if position.x-get_node("../boat").position.x>=0:
			get_node("../fishybar").position.x = get_node("../boat").position.x-64
		else:
			get_node("../fishybar").position.x = get_node("../boat").position.x+64
		get_node("../fishybar").position.y = get_node("../boat").position.y-64
		get_node("../fishybar/yellow").position.y = fishtype[1]
		get_node("../fishybar/green").position.y = 127
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://fishy.gd ��������      local://RectangleShape2D_ep8c7 Q         local://PackedScene_3ijqs �         RectangleShape2D       
     �A  �A         PackedScene          	         names "         fishy 	   position    script    Area2D    CollisionShape2D    shape    metadata/_edit_lock_ 
   ColorRect    offset_left    offset_top    offset_right    offset_bottom    color    Button    Timer 
   wait_time 	   one_shot 
   autostart    _on_button_pressed    pressed    _on_timer_timeout    timeout    	   variants       
      C  �B                                �      A         �?  �?  �?     �@      node_count             nodes     G   ��������       ����                                  ����                                 ����         	      
                                          ����         	      
                                    ����                               conn_count             conns                                                              node_paths              editable_instances              version             RSRC             extends Node2D

var greendir = -1
var score = 0
var meanscore=0
var poked = false
var pokenum = 1

func _ready():
	set_process(false)

func _process(delta):
	print(score)
	print(meanscore)
	if $green.position.y<=8:
		greendir=1
	if $green.position.y>=128:
		greendir=-1
	$green.position.y+=greendir*100*delta
	if Input.is_action_just_pressed("poke"):
		if $yellow in $green.get_overlapping_areas():
			if score < get_parent().get_child(-1).fishtype.size()-2:
				pokenum+=1
				$yellow.position.y = get_parent().get_child(-1).fishtype[pokenum]
			score+=1
			poked=true
		else:
			meanscore+=1
	
	if score == get_parent().get_child(-1).fishtype.size()-1:
		#add fish to inventory, you got a fish splashscreen
		visible=false
		get_node("../boat").canmove=true
		get_node("../boat/yippeefish").text = "you got "+get_parent().get_child(-1).fishtype[0]
		if get_parent().get_child(-1).name=="fishy":
			get_parent().get_child(-1).queue_free()
		score=0
		pokenum=1
		meanscore=0
		
		get_node("../boat/yippeefish").visible=true
		get_node("../boat/yippeetimer").start()
		get_node("../fishytimer").wait_time=randi_range(5,15)
		get_node("../fishytimer").start()
		get_parent().canfish=true
		set_process(false)
	if meanscore == 3:
		visible=false
		get_node("../boat").canmove=true
		if get_parent().get_child(-1).name=="fishy":
			get_parent().get_child(-1).queue_free()
		score=0
		meanscore=0
		pokenum=1
		get_node("../fishytimer").wait_time=randi_range(5,15)
		get_node("../fishytimer").start()
		get_parent().canfish=true
		set_process(false)


func _on_green_area_exited(area):
	if area==$yellow and !poked:
		meanscore+=1
	poked = false
      extends Node2D

var fishy
var canfish=true
# Called when the node enters the scene tree for the first time.
func _ready():
	fishy = load("res://fishy.tscn")
	$fishytimer.wait_time=randi_range(5,15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fishytimer_timeout():
	if canfish:
		$fishytimer.wait_time=randi_range(5,15)
		add_child(fishy.instantiate())
		get_child(-1).position=Vector2($boat.position.x+randi_range(-128,128),$boat.position.y+randi_range(-128,128))
		$fishytimer.start()
	
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://game.gd ��������   Script    res://boatmove.gd ��������   Script    res://fishybar.gd ��������      local://RectangleShape2D_cauat �         local://RectangleShape2D_q6bxi )         local://RectangleShape2D_yfq88 Z         local://PackedScene_7qdbu �         RectangleShape2D       
     �B   B         RectangleShape2D       
     �A   A         RectangleShape2D       
     �A  �A         PackedScene          	         names "   2      Node2D    script    boat 	   position    CharacterBody2D    Line2D    points    width    CollisionShape2D    shape    metadata/_edit_lock_ 
   ColorRect    offset_left    offset_top    offset_right    offset_bottom    color 	   Camera2D    position_smoothing_enabled    yippeefish    visible    text 	   editable    context_menu_enabled    shortcut_keys_enabled    selecting_enabled    deselect_on_focus_loss_enabled     drag_and_drop_selection_enabled    virtual_keyboard_enabled    middle_mouse_paste_enabled 	   TextEdit    yippeetimer 
   wait_time 	   one_shot    Timer    ColorRect2    fishytimer 
   autostart 	   fishybar    process_mode    no    yellow    Area2D    yelloww    green    _on_yippeetimer_timeout    timeout    _on_fishytimer_timeout    _on_green_area_exited    area_exited    	   variants    *             
     hC   B         
     h�   �%                    @                      �     ��      B     �A   ��?w�_>      �?            ��     ��     �B      you is got fishy!!!      @@     �C     �C      C     C     XC     0C     �C     �@                  {.?�ޖ>      �?      A     �A     C   ff�>�G!>      �?
      A  �B     �?  �?      �?
      A  �@         
      A  @B         �?      �?
      A  @A               node_count             nodes       ��������        ����                            ����                                ����                                      ����   	      
                       ����            	      
               
                       ����         
                       ����                                                                                                  "      ����          !                     #   ����                                             ����                                       "   $   ����          %                      &   ����   '                                (   ����   '         
                                ����                               !   
                 *   )   ����      "                 +   ����                  #   
                       ����      $   	   %   
                 *   ,   ����      &                 ,   ����                  '   
                       ����      (   	   )   
                conn_count             conns              .   -              
       .   /                    1   0                    node_paths              editable_instances              version             RSRC       GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://d04ugdiibvdx3"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-98ed4b6f6e0850185d15724f9bda0923-fishy.scn"
              [remap]

path="res://.godot/exported/133200997/export-609f762188a68253d349ec58c4f3a8d3-game.scn"
               list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              }KA��'d   res://fishy.tscn=��/   res://game.tscnnc�tߍ|   res://icon.svg           ECFG      application/config/name         boatgame   application/run/main_scene         res://game.tscn    application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg  
   input/poke�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility      