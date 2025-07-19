<?

class media_handler {

	private $filepath;

	private $main;

	public function __construct($filepath, $main=NULL) {
		$this->filepath = $filepath;
		$this->main = $main;
	}

	public function get($callback) {
		if($files->exists($filepath)) {
			$path_components = $files->remove_path_component_alt($filepath);
			$filename = '.'.$path_components['last_component'].'.mp3';
			$modified_filename = $files->append_path($path_components['remaining_path'], $filename);
			if($files->exists($modified_filename)) {
				$callback($modified_filename);
			} else {
				$original_modified_filename = $modified_filename;
				$split_filepath = $object->strings->split($filepath, '"');
				$split_modified = $object->strings->split($modified_filename, '"');
				$encapsed_quote = '"'.$object->strings->encaps_quotes('"').'"';
				$filepath = $object->strings->join($split_filepath, $encapsed_quote);
				$modified_filename = $object->strings->join($split_modified, $encapsed_quote);
				$audio->convert_mp3(function() {
					$callback($original_modified_filename);
				}, $filepath, $modified_filename);
			}
		}
	}

	public function to_aif($callback) {
		$object->log('called to aif');
		$filepath = $this->filepath;
		$this->main->make_accessible($filepath, function() {
			$object->log('accessible');
			if($files->exists($filepath)) {
				$path_components = $files->remove_path_component_alt($filepath);
				$filename = '.'.$path_components['last_component'].'.aif';
				$modified_filename = $files->append_path($path_components['remaining_path'], $filename);
				$object->log('exists');
				$object->log($filepath);
				$object->log($modified_filename);
				if($files->exists($modified_filename)) {
					$object->log('exists to mp3 completed');
					$callback($modified_filename);
				} else {
					$original_modified_filename = $modified_filename;
					$split_filepath = $object->strings->split($filepath, '"');
					$split_modified = $object->strings->split($modified_filename, '"');
					$encapsed_quote = '"'.$object->strings->encaps_quotes('"').'"';
					$filepath = $object->strings->join($split_filepath, $encapsed_quote);
					$modified_filename = $object->strings->join($split_modified, $encapsed_quote);
					$object->log('convert to mp3');
					$object->log($audio);
					$object->log($audio->convert_mp3);
					$audio->convert_mp3(function() {
						$object->log('convert to mp3 completed');
						$callback($original_modified_filename);
					}, $filepath, $modified_filename);
				}
			}
		});
	}
}

class metadata {

	public $tab;
	public $main;

	public $cover_folder;

	public function __construct($tab, $main) {
		$this->tab = $tab;
		$this->main = $main;

		$cover_folder = $files->get_library_path();
		$cover_folder = $files->append_path($cover_folder, 'covers');
		$this->cover_folder = $cover_folder;

		$object->log('cover folder');
		$object->log($this->cover_folder);
	}

	public function get($path, $id, $callback=NULL) {
		$self = $this;
		$media_handler = new media_handler($path, $this->main);
		$media_handler->to_aif(function($new_filename) {
			$object->log('to aif');
			$object->log($new_filename);
			$self->tab->get_metadata($new_filename, function($item) {
				$item['id'] = $id;
				if($object->isset($item['artwork']) && $item['artwork'] != NULL) {
					$artwork_filename = '';
					$split = $object->strings->split($item['artwork'], '/');
					if($split->length > 3) {
						$artwork_filename = $split[$split->length-3].'-'.$split[$split->length-2];
						$cover_image = $files->save_from_url_to_folder($item['artwork'], $self->cover_folder, $artwork_filename);
						if($cover_image != NULL) {
							$item['artwork'] = $cover_image; 
						}
					}
				}
				$callback($item);
				$files->delete($new_filename);
			});
		});
	}

}

?>