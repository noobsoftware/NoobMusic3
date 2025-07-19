<?

class indexing {

	public $sql;

	public $statement;

	public $extensions = ['wav', 'mp3', 'flac', 'm4a', 'aiff', 'aif', 'opus', 'ogg'];

	public function __construct($sql, $statement) {
		$this->sql = $sql;
		$this->statement = $statement;
	}

	public function index_files($library_location, $location_id=0) {
		$files_index = [];
		if($library_location != NULL) {
			$self = $this;
			$relative_path = '';
			$index = function($path, $relative_path, $print) {
				$files_list = $files->list_files($path);
				$count = $files_list->length;
				$counter = 0;
				$print_counter = 0;
				foreach($files_list as $file) {
					if($print && $print_counter == 500) {
						$print_counter = 0;
						$progress_value = $math->mult(100, ($counter/$count));
						$object->send('app.set_progress(data)', ['data' => $progress_value]);
					}
					$full_path = $files->append_path($path, $file);
					if($files->is_dir($full_path)) {
						$index($full_path, $files->append_path($relative_path, $file.'/'), false);
					} else {
						$extension = $object->strings->lower($files->get_extension($file));
						if($object->index_of($self->extensions, $extension) !== (-1) && $object->strings->strpos($file, '.') !== 0) {
							$files_index[] = $files->append_path($relative_path, $file);
						}
					}
					$print_counter = $print_counter+1;
					$counter = $counter+1;
				}
			};
			if($files->exists($library_location) && $files->is_dir($library_location)) {
				$index($library_location, '/', true);
			}
			foreach($files_index as $file_path) {
				if($object->strings->strpos($file_path, '/') != 0) {
					$file_path = '/'.$file_path;
				}
				$query = 'SELECT COUNT(*) as count FROM library WHERE relative_filepath = ? AND library_id = ?';
				$count = $this->sql->get_row($query, [$file_path, $location_id])['count'];
				if($count == 0 && $object->strings->strpos($file_path, '.DS_Store') == (-1)) {
					$song = [
						'check_value' => 1,
						'relative_filepath' => $file_path,
						'library_id' => $location_id
					];
					$insert = $this->statement->generate($song, 'library');
					$this->sql->_($insert, $song);
				}
			}
			return ['result' => 1];
		}
		return ['result' => 0];
	}

	public function clean_files($library_location, $location_id=0) {
		$query = 'SELECT * FROM library WHERE library_id = ?';
		$rows = $this->sql->get_rows($query, [$location_id]);
		if($library_location != NULL) {
			$counter = 0;
			$count = $rows->length;
			foreach($rows as $row) {
				$progress_value = $math->mult(100, ($counter/$count));
				$object->send('app.set_progress(data)', ['data' => $progress_value]);
				$path = $files->append_path($library_location, $row['relative_filepath']);
				if(!$files->exists($path)) {
					$id = $row['id'];
					$delete_query = 'DELETE FROM library WHERE id = ?';
					$this->sql->execute($delete_query, [$id]);
					$delete_query = 'DELETE FROM playlist_songs WHERE song_id = ?';
					$this->sql->execute($delete_query, [$id]);
				}
				$counter = $counter+1;
			}
		}
		return ['result' => 1];	
	}

	public function clean_lost_locations($locations) {
		$query = 'SELECT DISTINCT library_id FROM library';
		$library_ids = $this->sql->get_rows($query, []);

		$ids = $object->create();
		foreach($library_ids as $item) {
			$ids[$item['library_id']] = true;
		}

		$ids[0] = false;

		foreach($locations as $item) {
			$ids[$item['id']] = false;
		}

		foreach($ids as $location_id => $id_value) {
			if($id_value) {		
				$query = 'SELECT * FROM library WHERE library_id = ?';
				$rows = $this->sql->get_rows($query, [$location_id]);

				$counter = 0;
				$count = $rows->length;
				foreach($rows as $row) {
					$progress_value = $math->mult(100, ($counter/$count));
					$object->send('app.set_progress(data)', ['data' => $progress_value]);

					$id = $row['id'];
					$delete_query = 'DELETE FROM library WHERE id = ?';
					$this->sql->execute($delete_query, [$id]);
					$delete_query = 'DELETE FROM playlist_songs WHERE song_id = ?';
					$this->sql->execute($delete_query, [$id]);

					$counter = $counter+1;
				}
			}
		}
	}

}

?>