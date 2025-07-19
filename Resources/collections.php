<?

class collections extends item {
	
	public function load($v=NULL, $main_result=true) {
		$result = [];
		if($object->isset($v['id'])) {
			$query = 'SELECT * FROM '.$this->table_name.' WHERE parent_id = ?';
			$result = $this->sql->get_rows($query, [$v['id']]);
		} else {
			$query = 'SELECT * FROM '.$this->table_name.'';
			$result = $this->sql->get_rows($query, []);
		}

		$sub_ids = [];

		foreach($result as $row) {
			$row['sub_ids'] = [$row['id']];
			$intermediate_results = $this->load(['id' => $row['id']], false);
			
			$row['sub_ids'] = $object->concat($row['sub_ids'], $intermediate_results);
			

			$sub_ids = $object->concat($sub_ids, $row['sub_ids']);
		}

		if(!$main_result) {
			return $sub_ids;
		}

		$parent_id = 0;
		if($object->isset($v['id']) && $v['id'] != 0) {
			$query = 'SELECT * FROM '.$this->table_name.' WHERE id = ?';
			$row = $this->sql->get_row($query, [$v['id']]);
			$parent_id = $row['parent_id'];
			$sub_ids[] = $row['id'];
		}

		return ['items' => $result, 'sub_ids' => $sub_ids, 'parent_id' => $parent_id];
	}

	public function add_songs_to_collection($v=NULL) {
		foreach($v['song_ids'] as $song_id) {
			$item = [
				'id' => $song_id,
				'collections_id' => $v['collections_id']
			];
			$insert = $this->statement->generate($item, 'library');
			$this->sql->_($insert, $item);
		}
	}
}

?>