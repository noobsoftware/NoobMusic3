<?


class css_parser {

	public function parse($text) {
		$preg_split_instance = new preg_split('\{|\}', $text);
		$outer_split = $preg_split_instance->get();
		$inside_brackets = 0;
		$inside_media_query = false;

		$css_rules = [];
		$css_rule = $object->create();
		foreach($outer_split as $split_value) {
			$split_value = $object->strings->trim($split_value);
			if($object->strings->strlen($split_value) > 0) {
				
				if($split_value == '{') {
					$inside_brackets = $inside_brackets+1;
				} else if($split_value == '}') {
					$inside_brackets = $inside_brackets-1;
					if($inside_brackets == 0) {
						if($object->count($object->keys($css_rule)) > 0 && $set_properties) {
							$css_rules[] = $css_rule;
							$css_rule = $object->create();
							$set_properties = false;
							$inside_media_query = false;
						}
					}
				} else {
					if($inside_brackets == 0 && $object->strings->strpos($split_value, '@') === 0) {
						$inside_media_query = true;
						$css_rule['media'] = $this->parse_media_query($object->strings->trim($split_value));
					} else if(($inside_brackets == 1 && $inside_media_query) || ($inside_brackets == 0 && !$inside_media_query)) {
						$css_rule['selector'] = $this->parse_selector($object->strings->trim($split_value));
					} else if(($inside_brackets == 1 && $inside_media_query == false) || ($inside_brackets == 2 && $inside_media_query)) {
						$set_properties = true;

						$preg_split_instance = new preg_split('\:|\;', $split_value, true);
						$inner_split = $preg_split_instance->get();

						$property = true;
						$css_rule['property_values'] = $object->create();
						$property_name = NULL;
						foreach($inner_split as $rule_value) {
							$rule_value = $object->strings->trim($rule_value);
							if($property) {
								$property_name = $rule_value;
								$property = false;
							} else {
								$css_rule['property_values'][$property_name] = $this->parse_value($rule_value);
								$property_name = NULL;
								$property = true;
							}
						}
					}
				}
			}
		}
	
		return $css_rules;
	}

	public function parse_value($value) {
		if($object->strings->strpos($value, '%') !== (-1)) {
			$value = $object->strings->explode('%', $value)[0];
			$value = ['type' => '%', 'value' => $value];
		} else if($object->strings->strpos($value, 'px') !== (-1)) {
			$value = $object->strings->explode('px', $value)[0];
			$value = ['type' => 'px', 'value' => $value];
		}
		return $value;
	}

	public function parse_media_query($value) {
		return $value;
	}

	public function parse_selector($value) {
		/*
			Vantar kommu splitter
		*/
		$value = $object->regex->preg_replace('\s*>\s*', '>', $value);
		$split = $object->regex->preg_split('\s+|>', $value);
		$set_split = [];
		foreach($split as $selector_item) {
			/*$split[$key] = */
			$set_split_values = $object->regex->preg_split('\.|#|\:|\[|\]', $selector_item);
			$set_split_results = [];
			foreach($set_split_values as $sub_item) {
				if($object->strings->strlen($object->strings->trim($sub_item)) != 0) {
					/*delete ($split[$key][$sub_key]);*/
					$set_split_results[] = $object->strings->trim($sub_item);
				}
			}
			$set_split[] = $set_split_results;
			/*$split[$key] = $object->values($split[$key]);*/
		}
		return $set_split;
	}
}	

?>