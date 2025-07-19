<?

/*class html_element extends \ice\script_object {
	
	protected $parent;
	protected $children;

	public function __construct($window=NULL, $parent=NULL) {
		parent::__construct($window);
		$this->is_array = false;
	}
}*/


class window {

	public $layout;

	public $test_prop = 'test123';

	public function __construct($document, $parent=NULL, $parent_window=NULL) {
		/*parent::__construct();*/
		/*$self_instance->parent->__construct();*/

		$this->document = $document;
		$this->document->set_window($this);

		if($parent == NULL) {
			$this->layout = $object->get_layout();
		} else {
			$this->layout = $parent->get_layout();
		}

		/*$this->document = new document($this);*/
		/*$this->location = new location($this);*/
		/*$this->layout_manager = $object->layout_manager;*/
		/*new \ice\layout\layout_manager($this);*/
	}

	public function get_layout() {
		return $this->layout;
	}

	public function set_document($document) {
		$this->document = $document;
	}

	public function get_document() {
		return $this->document;
	}

	public function set_document_html($html) {
		$this->document->set_inner_html($html);
	}

	protected $width;
	protected $height;

	public function set_bounds($width, $height) {
		$this->width = $width;
		$this->height = $height;
	}

	public $document;
	protected $location;
	protected $layout_manager;

	/*function print_layout(\Xamarin\Forms\AbsoluteLayout $content, \System\Delegate $template) {
		$this->layout_manager->set_template($template);
		$this->layout_manager->print_layout($content);
	}*/

	public function print_layout($content, $template) {
		return false;
	}

	/*public function get_variable_value($name) {
		switch($name) {
			case 'document':
			case 'location':
				return $this->get_dictionary_value($name);
				break;
			default:
				return parent::get_variable_value($name);
				break;
		}
	}

	public function get_dictionary_value($name) {
		switch($name) {
			case 'document':
				return $this->document;
				break;
			case 'location':
				return $this->location;
				break;
			default:
				return parent::get_dictionary_value($name);
				break;
		}
	}*/

	public function get_computed_style($element) {
		return $element->get_computed_style();
	}	
}

class document extends html_element {
	public $style_manager;
	
	/*public function __construct($window=NULL) {
		$this->style_manager = new style_manager($this);
	}*/

	public function __init() {
		$this->style_manager = new style_manager($this);
	}

	public function set_inner_html($html) {
		$self_instance->parent->set_inner_html($html);
		$this->style_manager->compute_styles($this);
	}

	private $selector_tokens = ['.', '#', ':', '[', ']'];

	private function query_selector_sub($element_selector=NULL, $classes=[], $id=NULL, $attributes=[], $parent=NULL, $direct_descendants=false) {
		$elements_result = [];
		foreach($parent->get_children() as $child) {
			if($child != NULL && $object->instance_of($child, 'html_element')) {
				$valid = true;
				if($element_selector != NULL) {
					if($element_selector != $child->get_tag_name()) {
						$valid = false;
					}	
				}
				if($classes->length > 0) {
					foreach($classes as $class_value) {
						if(!$child->has_class($class_value)) {
							$valid = false;
						}
					}
				}
				if($id != NULL) {
					if($child->get_id() != $id) {
						$valid = false;
					}
				}
				if($attributes->length > 0) {
					foreach($attributes as $attribute) {
						if(!$child->attribute_is($attribute[0], $attribute[1])) {
							$valid = false;
						}
					}
				}
				if($valid) {
					$elements_result[] = $child;
				}
				if(!$direct_descendants) {
					$elements_result = $object->concat($elements_result, $this->query_selector_sub($element_selector, $classes, $id, $attributes, $child));
				}
			}
		}
		return $elements_result;
	}

	public function query_selector($selector, $parent=NULL) {
		if(!$object->item_is_array($selector, true)) {
			$css_parser = new css_parser();
			$selector = $css_parser->parse_selector($selector);
		}
		if($parent == NULL) {
			$parent = $this;
		}

		/*$selector = [$selector];*/

		$selected_elements = NULL;	
		foreach($selector as $selector_item) {
			$counter = 0;
			$element_selector = NULL;
			$next_part_label = NULL;
			$classes = [];
			$id = NULL;
			$attributes = [];
			$direct_descendants = false;
			$last_selector_item_part = NULL;
			if($object->count($selector_item) > 0) {
				foreach($selector_item as $selector_item_part) {
					/*$selector_item_part = [$selector_item_part];*/
					/*if($object->count($selector_item_part) == 0) {

					} else*/
					if($object->item_is_array($selector_item_part, true) && $object->count($selector_item_part) != 0) {
						if(/*$object->item_is_array($selector_item_part, true) && */
							$object->count($selector_item_part) == 1 && $selector_item_part[0] == '>') {
							$direct_descendants = true;
						}
					} else {
						if($counter == 0 && $object->index_of($this->selector_tokens, $selector_item_part) === (-1)) {
							$element_selector = $selector_item_part;
						} else {
							if($next_part_label == NULL && $object->index_of($this->selector_tokens, $selector_item_part) != (-1)) {
								if($selector_item_part == '.') {
									$next_part_label = 'class';
								} else if($selector_item_part == '#') {
									$next_part_label = 'id';
								} else if($selector_item_part == '[') {
									$next_part_label = 'attribute';
								}
							} else if($next_part_label != NULL) {
								if($next_part_label == 'class') {
									$classes[] = $selector_item_part;
								} else if($next_part_label == 'id') {
									$id = $selector_item_part;
								} else if($next_part_label == 'attribute') {
									$preg_split_instance = new preg_split('=|'.$object->strings->apos().'|"', $selector_item_part);
									$attribute_split_set = $preg_split_instance->get();
									$attribute_split = [];
									foreach($attribute_split_set as $attribute_item) {
										$attribute_item = $object->strings->trim($attribute_item);
										if($object->strings->strlen($attribute_item) > 0) {
											$attribute_split[] = $attribute_item;
										}
									}
									$attributes[] = $attribute_split;
								}
							}
						}
					}
					if($last_selector_item_part == '>' && $direct_descendants) {
						$direct_descendants = false;
					}
					if($object->count($selector_item_part) > 0) {
						$last_selector_item_part = $selector_item_part[0];
					} else {
						$last_selector_item_part = NULL;
					}
					$counter = $counter+1;
				}
				if($selected_elements == NULL) {
					$selected_elements = $this->query_selector_sub($element_selector, $classes, $id, $attributes, $parent, $direct_descendants);
				} else {
					$next_selected_elements = [];
					foreach($selected_elements as $selected_element) {
						$next_selected_elements = $object->concat($next_selected_elements, $this->query_selector_sub($element_selector, $classes, $id, $attributes, $selected_element, $direct_descendants));
					}
					$selected_elements = $next_selected_elements;
				}

			}
		}
		return $selected_elements;
	}
}

/*class location extends \ice\script_object {

	public function __construct($window) {
		$this->window = $window;
	}
}

class browser_window extends \ice\dom\window {
	public function test() {
		$this->document->test();
	}
}*/

?>