<?

class preg_split {

	public $results;

	public $matches;

	public function __construct($pattern, $text, $mark_delimiters=false) {
		$split_results = [];

		$text_length = $object->strings->strlen($text);

		$reg_match_results = $object->regex->reg_match($pattern, $text);
		$last_position = 0;
		foreach($reg_match_results as $value_item) {
			$position = $value_item->position;
			$substring_prefix = $object->strings->substr($text, $last_position, $position-$last_position);
			$substring_prefix = $object->strings->trim($substring_prefix);
			if($object->strings->strlen($substring_prefix) > 0) {
				$split_results[] = $substring_prefix;
			}
			$last_position = $position+$value_item->length_value;
			if(!$mark_delimiters) {
				$split_results[] = $value_item->value;
			}/* else {
				$split_results[] = $value_item;
			}*/
			$last_position = $last_position;
		}
		if($last_position < $object->strings->strlen($text)) {
			$substring_suffix = $object->strings->substr($text, $last_position, $text_length-$last_position);
			$split_results[] = $substring_suffix;
		}
		$this->results = $split_results;
	}

	public function get() {
		return $this->results;
	}
}

?>