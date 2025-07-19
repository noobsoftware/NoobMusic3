<?


class style_manager {

	protected $document;

	public function __construct($document=NULL) {
		$this->document = $document;
	}

	public $style_rules = [];

	public function run($text='') {

		/*$text = ".class_name > element .class2 {
			fontSize:test;
		}

		@media only screen and (max-width: 600px) {
			body {
				background-color: lightblue;
			}
		}";*/

		/*$text = preg_replace('\s+', ' ', trim($text));*/


		$preg_split_instance = new preg_split('\s+', $value);
		$text_items = $preg_split_instance->get();
		$set_text_items = [];

		foreach($text_items as $item) {
			$item = $object->strings->trim($item);
			if($object->strings->strlen($item) > 0) {
				$set_text_items[] = $item;
			}
		}

		$text = $object->strings->join($set_text_items, ' ');

		$css_parser = new css_parser();

		$result = $css_parser->parse($text);
		
		$this->style_rules = $object->concat($this->style_rules, $result);
	}

	public function compute_styles($document=NULL) {
		if($document == NULL) {
			$document = $this->document;
		}
		foreach($this->style_rules as $style_rule) {
			$selector = $style_rule['selector'];
			$elements = $document->query_selector($selector);
			foreach($elements as $selected_element) {
				$selected_element->set_computed_style($style_rule['property_values']);
			}
		}
	}
}

?>