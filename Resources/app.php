<?
class table_structure_update {
	public function __construct($init_command, $data_instance) {
		$create_commands = $object->strings->split($init_command, 'CREATE TABLE IF NOT EXISTS');
		foreach($create_commands as $item) {
			$table_parts = $object->strings->split($item, '(');
			if($table_parts->length > 1) {
				$nametrimmed = $object->strings->trim($table_parts[0]);
				$sub_items = $object->strings->split($table_parts[1], ')')[0];
				$sub_items = $object->strings->split($sub_items, ',');
				$index = 0;
				$columns = $data_instance->table_columns($nametrimmed);
				foreach($sub_items as $sub_item) {
					$sub_item_value = $object->strings->split($object->strings->trim($sub_item), ' ')[0];
					$flag = false;
					foreach($columns as $column) {
						if($column == $sub_item_value) {
							$flag = true;
						}
					}
					if(!$flag) {
						$data_instance->execute('ALTER TABLE '.$nametrimmed.' ADD COLUMN '.$sub_item, []);
					} else {
					}
				}
			}
		}
	}
}

class statement_depr {
	public function generate($x, $table) {
		$output = NULL;
		$keys = [];
		$type = 0;
		if($x->length > 0) {
			if($object->isset($x['id'])) {
				if($x['id'] == '-1') {
					$type = 1;	
				} else {
					$type = 0;	
				}
			} else {
				$type = 1;	
			}
			if($type == 0) {
				$output = 'UPDATE '.$table.' SET ';
				if($object->isset($x['id'])) {
					$counter = 0;
					foreach($x as $key => $x_value) {
						$keys[] = $key;
						if($key != 'id') {
							if($counter > 0) {
								$output = $output.', ';
							}
							$output = $output.$key.' = ?';
							$counter = $counter+1;
						}
					}
					$output = $output.' WHERE id = ?';
				}
			} else {
				$output = 'INSERT INTO '.$table.' (';
				$counter = 0;
				foreach($x as $key => $x_value) {
					$keys[] = $key;
					if($counter > 0) {
						$output = $output.', ';
					}
					$output = $output.$key;
					$counter = $counter+1;
				}
				$counter = 0;
				$output = $output.') VALUES (';
				foreach($x as $key => $x_value) {
					if($counter > 0) {
						$output = $output.', ';
					}
					$output = $output.'? ';
					$counter = $counter+1;
				}
				$output = $output.')';
			}
			$result_a = ['insert_query' => $output, 'table_name' => $table, 'type' => $type];
			return $output;
		}
		return NULL;
	}
}

class statement {
	public function generate($x, $table, $prevent_id_generating=false) {
		$output = NULL;
		$keys = [];
		$type = 0;
		if($object->isset($x['modified']) && $x['modified'] == (-1)) {
			delete $x['modified'];
		}
		if($x->length > 0) {
			if($object->isset($x['id'])) {
				if($x['id'] == '-1') {
					$type = 1;	
				} else {
					$type = 0;	
				}
			} else {
				$type = 1;	
			}
			if($type == 0) {
				$output = 'UPDATE '.$table.' SET ';
				if($object->isset($x['id'])) {
					$counter = 0;
					if($object->isset($x['created'])) {
						delete $x['created'];
					}
					foreach($x as $key => $x_value) {
						$keys[] = $key;
						if($key != 'id') {
							if($counter > 0) {
								$output = $output.', ';
							}
							if(($key == 'created' || $key == 'modified') && $object->strings->lower($x_value) == 'current_timestamp') {
								if($key != 'created') {
									$output = $output.$key.' = current_timestamp';
								}
							} else {
								$output = $output.$key.' = ?';
							}
							$counter = $counter+1;
						}
					}
					$output = $output.' WHERE id = ?';
				}
			} else {
				$output = 'INSERT INTO '.$table.' (';
				$counter = 0;
				foreach($x as $key => $x_value) {
					$keys[] = $key;
					if($counter > 0) {
						$output = $output.', ';
					}
					$output = $output.$key;
					$counter = $counter+1;
				}
				$counter = 0;
				$output = $output.') VALUES (';
				foreach($x as $key => $x_value) {
					if($counter > 0) {
						$output = $output.', ';
					}
					if(($key == 'created' || $key == 'modified') && $object->strings->lower($x_value) == 'current_timestamp') {
						$output = $output.'current_timestamp ';
					} else {
						$output = $output.'? ';
					}
					$counter = $counter+1;
				}
				$output = $output.')';
			}

			if($object->isset($x['modified']) && $x['modified'] == 'current_timestamp') {
				delete $x['modified'];
			}
			if($object->isset($x['created']) && $x['created'] == 'current_timestamp') {
				delete $x['created'];
			}
			
			return $output;
		}
		return NULL;
	}
}


class base {
	public $apps=NULL;
	private $dict = NULL;
	public function __construct($instance_input) {
		$data->statement = new statement();
		$object->deep_copy = function($input) {
			return $object->fromJSON($object->toJSON($input));
		};
		$object->index_of = function($input, $search_value) {
			foreach($input as $indexofkey => $value) {
				if($search_value == $value) {
					return $indexofkey;
				}
			}
			return 0-1;
		};
		$object->union = function($a, $b, $comparator) {
			foreach($b as $b_value) {
				$exists = false;
				foreach($a as $a_value) {
					$comparator_result = $comparator($a_value, $b_value);
					if($comparator_result) {
						$exists = true;
					}
				}
				if(!$exists) {
					$a[] = $b_value;
				}
			}
			return NULL;
		};
		$object->map = function($arr, $func) {
			$result = [];
			foreach($arr as $row) {
				$result[] = $func($row);
			}
			return $result;
		};
    	$files->append_path = function($path, $file) {
    		$path_strlen = $object->strings->strlen($path);
    		$strrev = $object->strings->strrev($path);
    		if($object->strings->strpos($strrev, '/') == 0) {
    			$path = $object->strings->substr($path, 0, $path_strlen-1);
    		}
    		if($object->strings->strpos($file, '/') != 0) {
    			$file = '/'.$file;
    		}
    		return $path.$file;
    	};
    	/*$object->create = function($input) {
			$created_object = ['test' => 'test'];
			delete $created_object['test'];
			return $created_object;
		};*/

		$object->count = function($arr) {
			return $arr->length;
		};

		$object->get_first_row = function($rows) {
			if($rows->length > 0) {
				return $rows[0];
			}
			return NULL;
		};

		$object->array_keys = function($value) {
			return $object->keys($value);
		};

    	$files->append_path_depr = function($path, $file) {
    		$path_strlen = $object->strings->strlen($path);
    		$strrev = $object->strings->strrev($path);
    		if($object->strings->strpos($strrev, '/') == 0) {
    			$path = $object->strings->substr($path, 0, $path_strlen-1);
    		}
    		if($object->strings->strpos($file, '/') != 0) {
    			$file = '/'.$file;
    		}
    		return $path.$file;
    	};

    	$object->strings->explode = function($delimiter, $value) {
    		return $object->strings->split($value, $delimiter);
    	};

    	$object->strings->implode = function($delimiter, $values) {
    		return $object->strings->join($values, $delimiter);
    	};

    	$object->regex->preg_split = function($regex_value, $text, $mark_delimiters) {
			$preg_split_instance = new preg_split($regex_value, $text, $mark_delimiters);
			return $preg_split_instance->get();
		};

		$object->regex->preg_replace = function($regex_value, $replace_value, $text) {
			$split = $object->regex->preg_split($regex_value, $text, true);
			return $object->strings->join($split, $replace_value);
		};

		$this->apps = [
			'main' => new main_app($this)
    	];

	}

	public $indexing_in_progress = false;

    public function receive_messages($message) {
    	/*$object->log($self_instance);*/
    	$message_counter = $message['message_counter'];
    	delete $message['message_counter'];

    	$action = $message['action'];
    	delete $message['action'];
    	$result = NULL;
		if($this->indexing_in_progress) {
			return $object->toJSON([
	        	'message_counter' => $message_counter,
	        	'message' => $result,
	        	'stall' => true
	        ]);
		}
		
    	if($object->isset($message['callback_result'])) {
    		delete $message['callback_result'];
    		$this->apps['main'][$action]($message, function($result_data) {

		        if(!$object->isset($result_data) || $result_data == NULL) {
		        	$result_data = '0';
		        }
		        $data_res =	[
    				'data' => [
	    				'message_counter' => $message_counter, 
	    				'message' => $result_data
	    			]
    			];
    			$object->send('app.receive_messages(data)', $data_res);
    		});
    		$res = [
	        	'message_counter' => (-1),
	        	'message' => 0
	        ];
	        return $res;
    	} else {
	    	$result = $this->apps['main'][$action]($message);
	    }

	    /*return [
        	'message_counter' => $message_counter,
        	'message' => $result
        ];*/
        /*if(!$object->isset($result) || $result == NULL) {
        	$result = '0';
        }

        $object->log($result);*/
        if(!$object->isset($result) || $result == NULL) {
        	$result = '0';
        }

        $res = [
        	'message_counter' => $message_counter,
        	'message' => $result
        ];

        return $res;
    }
}
$base_instance = new base(NULL);

?>
