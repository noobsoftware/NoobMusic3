<?

class item {

	protected $table_name;

	protected $sql;
	protected $statement;

	public function __construct($table_name, $sql, $statement) {
		$this->table_name = $table_name;
		$this->sql = $sql;
		$this->statement = $statement;
	}

	public function load($v=NULL) {
		$query = 'SELECT * FROM '.$this->table_name.'';
		$rows = $this->sql->get_rows($query, []);
		return $rows;
	}	

	public function _($v=NULL) {
		$insert = $this->statement->generate($v, $this->table_name);
		$this->sql->_($insert, $v);
		$id = $this->sql->last_id($v);
		return $id;
	}

	public function delete($id) {
		$query = 'DELETE FROM '.$this->table_name.' WHERE id = ?';
		$this->sql->execute($query, [$id]);
	}

}

?>