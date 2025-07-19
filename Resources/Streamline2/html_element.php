<?

class html_element {

	private $layout = NULL;

	public function __construct($window=NULL, $parent_element=NULL) {
		/*if($parent_element == NULL) {
			$parent_element = $window->get_document();
		}*/
		/*$this->window = $window;*/
		$this->parent_element = $parent_element;
		if($window != NULL) {
			$this->window = $window;
		} else {
			if($this->parent_element != NULL) {
				$this->window = $this->parent_element->get_window();
			}
		}
		
		$this->attributes = $object->create();

		if($object->isset($this->__init)) {
			$this->__init();
		}
	}

	public function init_tag($tag_name) {
		$this->tag_name = $tag_name;
	}

	public function query_selector($selector) {
		return $this->window->get_document()->query_selector($selector, $this);
	}

	public function in_body() {
		if($this->tag_name == 'body') {
			return true;
		}
		if($this->parent_element != NULL) {
			return $this->parent_element->in_body();
		}
		return false;
	}

	private $media_tab;

	public function get_media_tab() {
		return $this->media_tab;
	}

	public function make_layout($from_window=false) {
		$object->log('in make layout: '.$from_window);
		$object->log('make layout: '.$this->tag_name);
		if($this->in_body()) {
			if($this->layout === NULL) {
				if($this->parent_element != NULL && !$from_window) {
					if($this->tag_name != 'video') {
						$this->layout = $this->parent_element->get_layout()->make($this, $this->get_box());	
					} else {
						$this->layout = $this->parent_element->get_layout()->make($this, $this->get_box(), true);
						$this->media_tab = $media->add_tab($this->layout);
					}
				} else if($this->window != NULL) {
					$layout_window = $this->window->get_layout();
					$this->layout = $layout_window->make($this, [
						'set_rectangle' => [
							0, 0, 0, 0
						]
					]);
				}
				if($this->tag_name == 'web') {
					/*if(!$object->isset($object->webview_index_value)) {
						$object->webview_index_value = 0;
					} else {
						$object->webview_index_value = $object->webview_index_value + 1;
					}*/
					$object->log('assign webview');
					$this->webview = $this->layout->assign_web_view(-1);
					/*$object->log($object->toJSON($this->attributes));*/
					if($object->isset($this->attributes['type']) && $this->attributes['type'] == 'overlay') {
						if($object->isset($this->attributes['src'])) {
							/*$this->webview->load_request($this->attributes['src'], true);*/
							$object->log('load file '.$this->attributes['src']);
							$this->webview->load_file($this->attributes['src']);
						}
					} else {
						$set_webview = $this->webview;
					}
				} else if($this->tag_name == 'style') {
					$object->log('style');
					if($this->children->length > 0) {
						$inner_text = $this->children[0];

					}
				}
				$object->log('children: '.$this->children->length);
				foreach($this->children as $child) {
					if($object->instance_of($child, 'html_element')) {
						/*vantar make layout fyrir textnodes*/
						$child->make_layout();
					}
				}
			}/* else {
				append detach remove
			}*/
		}
	}

	

	public function get_layout() {
		return $this->layout;
	}

	protected $inner_text;

	public function set_inner_text($inner_text) {
		$this->inner_text = $inner_text;
	} 

	public function get_inner_text() {
		return $this->inner_text;
	}

	protected $view;

	public function set_window($window) {
		$this->window = $window;
	}

	public function get_window() {
		return $this->window;
	}


	protected $window;
	protected $namespace;

	protected $parent_element;
	protected $tag_name = 'unknown';
	protected $classes = [];
	protected $id;

	public function get_parent() {
		return $this->parent_element;
	}

	protected $computed_style = [];

	public function reset_computed_style() {
		$this->computed_style = [];
	}

	public function get_computed_style() {
		return $this->computed_style;
	}

	public function attribute_is($attribute_name, $attribute_value) {
		if($object->isset($this->attributes[$attribute_name])) {
			if($object->strings->trim($this->attributes[$attribute_name]) == $object->strings->trim($attribute_value)) {
				return true;
			}
		}
		return false;
	}

	public function set_computed_style($style, $reset=false) {
		/*if($reset) {*/
			$this->computed_style = $style;
		/*} else {
			$this->computed_style = $object->concat($style, $this->computed_style);
		}*/
	}
	
	public function get_box() {
		/*
        @"set_height": @50,
        @"set_width": @50,
        @"width_type": @1,
        @"height_type": @1,
        @"orientation": @1,
        @"display": @true*/
		/*return [
			'set_height' => 50,
			'set_width' => 50,
			'width_type' => 1,
			'height_type' => 1,
			'orientation' => 1,
			'display' => true
		];*/

		$results = $object->create();

		if($object->isset($this->computed_style['width'])) {
			$results['set_width'] = $this->computed_style['width']['value'];
			$results['width_type'] = 0;
			if($this->computed_style['height']['type'] == '%') {
				$results['width_type'] = 1;
			}
		}

		if($object->isset($this->computed_style['height'])) {
			$results['set_height'] = $this->computed_style['height']['value'];
			$results['height_type'] = 0;
			if($this->computed_style['height']['type'] == '%') {
				$results['height_type'] = 1;
			}
		}

		if($object->isset($this->computed_style['orientation'])) {
			$results['orientation'] = $this->computed_style['orientation'];
		}

		if($object->isset($this->computed_style['overflow'])) {
			$results['overflow'] = $this->computed_style['overflow'];
		}

		if($object->isset($this->computed_style['display'])) {
			$results['display'] = $this->computed_style['display'];
		}

		if($object->isset($this->computed_style['horizontal_alignment'])) { /*0,1,2*/
			$results['horizontal_alignment'] = $this->computed_style['horizontal_alignment'];
		}

		if($object->isset($this->computed_style['vertical_alignment'])) { /*0,1,2*/
			$results['vertical_alignment'] = $this->computed_style['vertical_alignment'];
		}

		$rectangle = [-1, -1, -1, -1];
		$rectangle_type = [0, 0, 0, 0];
		if($object->isset($this->computed_style['left'])) {
			$rectangle[0] = $this->computed_style['left']['value'];
			if($this->computed_style['left']['type'] == '%') {
				$rectangle_type[0] = 1; 
			}
		}
		if($object->isset($this->computed_style['top'])) {
			$rectangle[1] = $this->computed_style['top']['value'];
			if($this->computed_style['top']['type'] == '%') {
				$rectangle_type[1] = 1; 
			}
		}
		if($object->isset($this->computed_style['right'])) {
			$rectangle[2] = $this->computed_style['right']['value'];
			if($this->computed_style['right']['type'] == '%') {
				$rectangle_type[2] = 1; 
			}
		}
		if($object->isset($this->computed_style['bottom'])) {
			$rectangle[3] = $this->computed_style['bottom']['value'];
			if($this->computed_style['bottom']['type'] == '%') {
				$rectangle_type[3] = 1; 
			}
		}
		$results['set_rectangle'] = $rectangle;
		$results['rectangle_type'] = $rectangle_type;
		$rectangle_addition = [0, 0, 0, 0];
		$rectangle_subtraction = [0, 0, 0, 0];

		if($object->isset($this->computed_style['left_addition'])) {
			$rectangle_addition[0] = $this->computed_style['left_addition']['value'];
		}
		if($object->isset($this->computed_style['top_addition'])) {
			$rectangle_addition[1] = $this->computed_style['top_addition']['value'];
		}
		if($object->isset($this->computed_style['width_addition'])) {
			$rectangle_addition[2] = $this->computed_style['width_addition']['value'];
		}
		if($object->isset($this->computed_style['height_addition'])) {
			$rectangle_addition[3] = $this->computed_style['height_addition']['value'];
		}
		if($object->isset($this->computed_style['left_subtraction'])) {
			$rectangle_subtraction[0] = $this->computed_style['left_subtraction']['value'];
		}
		if($object->isset($this->computed_style['top_subtraction'])) {
			$rectangle_subtraction[1] = $this->computed_style['top_subtraction']['value'];
		}
		if($object->isset($this->computed_style['width_subtraction'])) {
			$rectangle_subtraction[2] = $this->computed_style['width_subtraction']['value'];
		}
		if($object->isset($this->computed_style['height_subtraction'])) {
			$rectangle_subtraction[3] = $this->computed_style['height_subtraction']['value'];
		}
		$results['rectangle_addition'] = $rectangle_addition;
		$results['rectangle_subtraction'] = $rectangle_subtraction;


		return $results;
	}

	public function get_classes() {
		if($object->isset($this->attributes['class'])) {
			return $this->attributes['class'];
		}
		return [];
	}

	public function has_class($class_value) {
		if($object->isset($this->attributes['class'])) {
			foreach($this->attributes['class'] as $compare) {
				if($class_value == $compare) {
					return true;
				}
			}
		}	
		return false;
	}

	public function get_id() {
		if($object->isset($this->attributes['id'])) {
			return $this->attributes['id'];
		}
		return NULL;
	}

	protected $children = [];

	public function set_namespace($namespace) {
		$this->namespace = $namespace;
	}

	public function set_children($children) {
		$this->children = $children;
	}

	public function add_child($child) {
		$this->children[] = $child;
	}

	public function get_children() {
		return $this->children;
	}

	public function set_tag_name($tag_name) {
		$this->tag_name = $tag_name;
	}

	public function get_tag_name() {
		return $this->tag_name;
	}

	public function get_namespace() {
		return $this->namespace;
	}

	public function parse_tag($tag_value) {
		$values = $tag_value['value_set'];
		$attribute_values = $tag_value['attributes'];


		$value = $values[0];
		$preg_split_instance = new preg_split('\s+', $object->strings->trim($value), true);

		$split = $preg_split_instance->get();


		if($object->count($split) > 0) {
			$tag_name = $split[0];
			$this->set_tag_name($tag_name);




			if($object->isset($split[1])) {
				$values[0] = $split[1];
			} else {
				$values = [];
			}
		}


		$index_offset = 0;
		foreach($values as $key => $value) {
			if($object->strings->strpos($value, '=') !== (-1)) {
				$split = $object->strings->explode('=', $value);
				$attribute_name = $object->strings->trim($split[0]);
				$key_value = $key+$index_offset;
				$property_value = $object->strings->implode('', $attribute_values[$key_value]);
				$this->set_attribute($attribute_name, $property_value);
			} else {
				$this->set_attribute($object->strings->trim($value), NULL);
				$index_offset = $index_offset-1;
			}
		}


		return $this->tag_name;
	}

	protected $webview;

	public function get_webview() {
		return $this->webview;
	}

	protected $attributes = NULL;

	protected $style_manager;

	public function set_attribute($attribute_name, $value) {
		if($attribute_name == 'class') {
			$preg_split_instance = new preg_split('\s+', $value);
			$value = $preg_split_instance->get();
			/*$value = $object->map($value, function($e) {
				return $e->value;
			});*/
			$this->attributes[$attribute_name] = $value;
		} else if($attribute_name == 'style') {
			$this->attributes[$attribute_name] = $value;
			/*setja inn style manager*/
			if($this->style_manager == NULL) {
				$this->style_manager = new style_manager();
			}
			$style_manager = $this->style_manager; /*new style_manager();*/
			$style_manager->run($value);
			$styles = $style_manager->style_rules;

			$this->set_computed_style($styles);
		} else {
			$this->attributes[$attribute_name] = $value;
		}		
	}

	/*function parse_property_value($value) {
		$first_character = $object->strings->substr($value, 0, 1);
		$last_character = $object->strings->substr($value, $object->strings->strlen($value)-1, 1);
		//var_dump($first_character, $last_character);
		if($first_character == "'" && $last_character == "'") {
			//$split = preg_split("/(\s|'|\")/", $object->strings->trim($value));
			$split = preg_split("/(\s|')/", $object->strings->trim($value));
			foreach($split as $key => $value) {
				if($object->strings->strlen($object->strings->trim($value)) > 0) {
					return $value;
				}
			}
		} else if($fist_character == '"' && $last_character == '"') {
			$split = preg_split("/(\s|\")/", $object->strings->trim($value));
			foreach($split as $key => $value) {
				if($object->strings->strlen($object->strings->trim($value)) > 0) {
					return $value;
				}
			}
		} else if(is_numeric($value)) {
			return $value;
		}
		return NULL;
	}*/

}

?>