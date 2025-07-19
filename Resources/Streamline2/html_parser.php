<?

class html_parser {

	private $source;

	private $tokens = [];

	public function preprocess() {
		return false;
	}

	public function __construct($source) {
		$this->source = $source;

		$preg_split_instance = new preg_split('(<|>|'.$object->strings->apos().'|\")', $source);

		$this->tokens = $preg_split_instance->get();
		$this->inner_text_index = [];

		$open_quote = (-1);
		$open_tag = (-1);
		$tokens_set = [];
		$current_token = NULL;
		$current_attribute_value = NULL;
		foreach($this->tokens as $key => $value) {
			if($object->strings->strlen($object->strings->trim($value)) != 0) {
				if(($open_tag === 0 && $value != '<' && $value != '>') || ($open_tag === 0 && $open_quote !== (-1))) {
					if($value == $object->strings->apos() && ($open_quote === (-1) || $open_quote === 0)) {
						if($open_quote === (-1)) {
							$open_quote = 0;
						} else if($open_quote === 0) {
							$open_quote = (-1);
							if($current_attribute_value != NULL) {
								$current_token['attributes'][] = $current_attribute_value;
							}
						}
					} else if($value == '"' && ($open_quote === (-1) || $open_quote === 2)) {
						if($open_quote === (-1)) {
							$open_quote = 2;
						} else {
							$open_quote = (-1);
							if($current_attribute_value != NULL) {
								$current_token['attributes'][] = $current_attribute_value;
							}
						}
					} else {
						if($open_quote == (-1)) {
							$current_token['value_set'][] = $value;
							$current_attribute_value = [];
						} else {
							$current_attribute_value[] = $value;
						}
					}
				} else if($value != '<' && $value != '>') {
					$tokens_set[] = ['value' => $value, 'type' => 'inner_text'];
				}
				if($value == '<' && ($open_tag == 1 || $open_tag == (-1))) {
					$open_tag = 0;
					$current_token = ['value' => NULL, 'value_set' => [], 'type' => 'tag', 'attributes' => []];
				} else if($value == '>') {
					$tokens_set[] = $current_token;
					$open_tag = 1;
				}
			}
		}
		foreach($tokens_set as $key => $value) {
			if($value['type'] == 'tag') {
				$value['value'] = $value['value_set'][0];
			}
		}
		$this->tokens = $tokens_set;
	}

	private $current_element = NULL;

	public function parse($current_element=NULL, $index=0) {
		$window = NULL;
		$is_document = false;
		$document = NULL;
		if($current_element == NULL) {

			/*$window = new window();*/
			$current_element = new document();
			$document = $current_element;
			/*$this->style_manager = new style_manager($current_element);*/
			$this->style_manager = $current_element->style_manager;
			$window = new window($current_element);
			$is_document = true;
		}

		$current_element->set_tag_name('document');
		$current_element->set_children($this->sub_parse($current_element, $this->tokens));

		if($this->set_style != NULL) {
			$this->style_manager->run($this->set_style);
			$this->style_manager->compute_styles($document);
		}

		if($is_document) {
			$object->log('is document');
			$body = $current_element->query_selector('body');
			if($body->length > 0) {
				$object->log('make body');
				$object->log($body[0]);

				$body[0]->make_layout(true);
				$object->log('after make layout');
				return $body[0];
			}
		}
		/**/
		return $current_element;
	}

	public $style_manager;

	private $set_style = NULL;

	public function sub_parse($parent_element, $tokens) {
		$elements = [];
		$index = 0;
		$token;


		$current_element;
		while($index < $object->count($tokens)) {
			$token = $tokens[$index];
			if($object->strings->substr($object->strings->trim($token['value']), 0, 1) != '/') {
				$tag_name = NULL;
				if($tokens[$index]['type'] == 'tag') {
					$current_element = new html_element($parent_element->get_window(), $parent_element);
					/*$parent_element = $current_element;*/
				} else if($tokens[$index]['type'] == 'inner_text') {
					if($parent_element->get_tag_name() == 'style') {
						$style_manager = $this->style_manager; /*new css_parser();*/
						$this->set_style = $token['value'];

					}/* else {
						$current_element = new html_inner_text();
						$current_element->set_inner_text($token['value']);
						$object->log('inner text');
						$object->log($token['value']);
						$object->log($object->toJSON($token));
					}*/
				}
				if($current_element != NULL) {
					$elements[] = $current_element;
					
					if($tokens[$index]['type'] == 'tag') {
						$tag_name = $current_element->parse_tag($token);
					} else {
						$tag_name = NULL;
						$current_element->set_value($token['value']);
					}
					$index = $index+1;
					if($tag_name != NULL) {
						$sub_tokens = [];
						$closing_tag_found = false;
						$open_tag_count = 1;
						while(!$closing_tag_found && $index < $object->count($tokens)) {
							$token = $tokens[$index];
							$sub_tokens[] = $token;

							if($object->strings->strpos($object->strings->trim($token['value']), '/') === 0) {
								$open_tag_count = $open_tag_count-1;
							} else {
								$open_tag_count = $open_tag_count+1;
							}


							if(('/'.$tag_name) == $object->strings->trim($token['value']) && $open_tag_count === 0) {
								$closing_tag_found = true;
							}/* else if($token['value'] {

							}*/
							$index = $index+1;
						}
						$current_element->set_parse_tokens = $sub_tokens;
						$sub_parse_value = $this->sub_parse($current_element, $sub_tokens);
						$current_element->set_children($sub_parse_value);
					}
				} else {

					$index = $index+1;
				}
			} else {
				$index = $index+1;
			}
		}
		return $elements;
	}
}

class html_inner_text {

	protected $value;

	public function set_value($string) {
		$this->value = $string;
	}

	public function get_value() {
		return $this->value;
	}
}



?>