<?

class main_app {

	private $sql;
	
	private $statement;

	private $dates;

	public $base_instance = NULL;

	public function __construct($base_instance) {
		$this->sql = $data->fetch('main');
		$this->statement = $data->statement;
		$this->base_instance = $base_instance;

		$self_sql = $this->sql;
		$this->sql->last_id = function($v) {
			if($object->isset($v['id'])) {
				return $v['id'];
			}
			return $self_sql->last_insert_id();
		};

		$init_string = 'CREATE TABLE IF NOT EXISTS settings (
			id INTEGER primary key autoincrement,
			property_name TEXT,
			property_value TEXT );

			CREATE TABLE IF NOT EXISTS collections (
				id integer primary key autoincrement,
				title text,
				parent_id integer DEFAULT 0
			);

			CREATE TABLE IF NOT EXISTS collections_artists (
				collections_id integer,
				artist_name text
			);

			CREATE TABLE IF NOT EXISTS collections_songs (
				collections_id integer,
				song_id integer
			);
			
			CREATE TABLE IF NOT EXISTS library (
			id INTEGER primary key autoincrement,
			relative_filepath TEXT,
			title TEXT,
			artist TEXT,
			artwork TEXT,
			album TEXT,
			year TEXT,
			comment TEXT,
			track TEXT,
			genre TEXT,
			pictures TEXT,
			lyrics TEXT,
			length TEXT,
			track_length TEXT,
			size TEXT,
			plays INTEGER,
			last_played DATETIME,
			date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
			tags TEXT,
			rating INTEGER,
			check_value BOOLEAN,
			has_read_info BOOLEAN DEFAULT 0,
			current_position DOUBLE DEFAULT 0,
			collections_id integer DEFAULT 0,
			library_id integer DEFAULT 0,
			apple_music_url TEXT
			);

			CREATE TABLE IF NOT EXISTS locations (
				id integer primary key autoincrement,
				path text
			);
			
			CREATE TABLE IF NOT EXISTS playlists (
			id INTEGER primary key autoincrement,
			name TEXT,
			parent_id INTEGER default -1,
			is_folder BOOLEAN,
			sort_resource TEXT,
			sort_direction TEXT,
			last_played_song_id INTEGER,
			songs_order TEXT ); 
			
			CREATE TABLE IF NOT EXISTS playlist_songs (
			id INTEGER primary key autoincrement,
			playlist_id INTEGER,
			song_id INTEGER,
			song_order INTEGER ); 
			
			CREATE TABLE IF NOT EXISTS numrand (
			id INTEGER primary key autoincrement,
			particle_x double,
			particly_y double,
			particle_y double,
			particle_direction double,
			phase_0 integer,
			phase_1 integer,
			phase_2 integer,
			phase_3 integer,
			phase_4 integer,
			phase_5 integer,
			phase_6 integer,
			phase_7 integer,
			phase_8 integer,
			phase_9 integer,
			phase_10 integer,
			phase_11 integer,
			phase_12 integer );

			CREATE TABLE IF NOT EXISTS filters (
			id INTEGER primary key autoincrement,
			name TEXT
			);

			CREATE TABLE IF NOT EXISTS filter_constraints (
			id INTEGER primary key autoincrement,
			type TEXT,
			condition TEXT,
			condition_type TEXT,
			value TEXT,
			value_type TEXT,
			filter_id INTEGER
			);

			CREATE TABLE IF NOT EXISTS shuffle_templates (
				id integer primary key autoincrement,
				tags TEXT
			)';

		$init_tables = $object->strings->split($init_string, ';');

		foreach($init_tables as $init_table) {
			if($init_table != NULL && $object->strings->strlen($init_table) > 0) {
				$this->sql->execute($init_table, []);
			}
		}
		$table_update = new table_structure_update($init_string, $this->sql);


		$this->media = $media->add_tab(NULL);

		$this->media->register_callback(function($par) {
			return 0;
		});
		$this->media->register_callback(function($par) {
			return 0;
		});
		$this->media->register_callback(function($par) {
			$object->send('app.ended(data)', ['data' => NULL]);
		});

		$this->collections = new collections('collections', $this->sql, $this->statement);
		$this->additional_locations = new additional_locations('locations', $this->sql, $this->statement);

		$object->log('run main');

		$this->run_main();
	}

	public function run_main() {
		/*$preg_split = new preg_split('(<|>|\")', '<value prop="test"></value>');
		$res = $preg_split->get();
		$object->log($object->toJSON($res));*/

		$source = $files->read_text('streamline2/main', 'html');
		/*
				<div class="c_container">
					<video class="preview"></video>
				</div>*/
		/*
				<div class="web_container">
					<web></web>
				</div>*/


		$html_parser_instance = new html_parser($source);
		$res = $html_parser_instance->parse();

		$object->log('run main1');
		$object->log($res);

		$web_main_item = $res->get_window()->get_document()->query_selector('web.mainweb')[0];


		$object->log('run main1');

		$object->web_main_item = $web_main_item->get_webview();

		$object->send = function($eval_string, $arguments) {
			$object->web_main_item->evaluate($eval_string, NULL, $arguments);
		};


		$object->log('run main1');

		$self = $this;

		$object->web_main_item->init_messages(function($message_value) {
			$data_res = $self->base_instance->receive_messages($message_value);
			if($object->isset($data_res) && $data_res != NULL && $data_res['message_counter'] != (-1)) {
	    		$object->send('app.receive_messages(data)', ['data' => $data_res]);
	    	}
		});

		$object->assign_global_callback('fullscreen', function() {
			$outer = $res->get_window()->get_document()->query_selector('.outer')[0];

			$set_box_value = [
	            'set_rectangle' => [0, 0, 0, 0]
			];


			$outer->get_layout()->set_box($set_box_value);
			$outer->get_layout()->animate((350/1000), [(59/100), (17/100), (5/10), (91/100)], [], async function() {
				$object->log('noobscript callback');
			});
		});

		$object->assign_global_callback('exit_fullscreen', function() {
			$outer = $res->get_window()->get_document()->query_selector('.outer')[0];

			$set_box_value = [
	            'set_rectangle' => [0, 30, 0, 0]
			];


			$outer->get_layout()->set_box($set_box_value);
			$outer->get_layout()->animate((350/1000), [(59/100), (17/100), (5/10), (91/100)], [], async function() {
				$object->log('noobscript callback');
			});
		});
		$object->log('run main completed');
	}

	public function get_metadata($v, $callback) {
		if(!$files->exists($v['filepath'])) {
			$callback($object->create());
			return false;
		}

		$metadata = new metadata($this->media, $this);
		$metadata->get($v['filepath'], $v['id'], $callback);

		/*return ['result' => 'get_metadata'];*/
	}

	public $supported_web_types = ['mp3'];

	public function load_media_part($v=NULL, $callback=NULL) {
		$filepath = $v['filepath'];
		$self = $this;
		$this->make_accessible($filepath, function() {
			$extension = $object->strings->lower($files->get_extension($filepath));
			if($object->index_of($self->supported_web_types, $extension) === (-1)) {
				$media_handler = new media_handler($filepath);
				$filepath = $media_handler->get(function($result) {
					if($files->exists($result)) {
						$callback($files->get_file_part($result, $v['part']));
					} else {
						$callback('');
					}
				});
			} else {
				$callback($files->get_file_part($filepath, $v['part']));
			}
		});
		return NULL;
	}

	private $additional_locations;

	public function delete_additional_location($v) {
		$this->additional_locations->delete($v['id']);
		return true;
	}

	public function load_additional_locations($v=NULL) {
		return $this->additional_locations->load($v);
	}

	public function choose_location_folder($v=NULL) {
		$library_location = '/';
		$self = $this;
		$files->picker($library_location, true, false, function($path) {
			if($files->exists($path) && $files->is_dir($path)) {
				$v['path'] = $path;
				$self->_additional_location($v);
				$object->send('app.settings.library.additional_locations.load(data)', ['data' => 'test']);
			} else {
				$object->send('app.loading.invalid_folder(data)', ['data' => 'Invalid folder']);
			}
		});
		return ['res' => 1];
	}

	public function _additional_location($v) {
		return $this->additional_locations->_($v);
	}

	public function update_songs($v=NULL) {
		foreach($v['songs'] as $item) {
			$insert = $this->statement->generate($item, 'library');
			$this->sql->_($insert, $item);
		}
		return ['result' => true];
	}

	private $collections;

	public function _collection_item($v=NULL) {
		$id = $this->collections->_($v);
		return ['id' => $id];
	}

	public function load_collections($v=NULL) {
		return $this->collections->load($v);
	}

	public function add_songs_to_collection($v=NULL) {
		$this->collections->add_songs_to_collection($v);
		return ['result' => true];
	}

	public function get_current_tab_time($v=NULL) {
		if($this->media != NULL) {
			$current_time = $this->media->time();
			$total_time = $this->media->total_time();
			return [
				'total_time' => $total_time,
				'current_time' => $current_time
			];
		}
		return [
			'current_time' => 0,
			'total' => 0
		];
	}

	public function set_playing_position($v=NULL) {
		$update_data = [
			'id' => $v['song_id'],
			'current_position' => $v['position']
		];

		$insert = $this->statement->generate($update_data, 'library');
		$this->sql->_($insert, $update_data);
		return ['result' => 1];
	}

	public function get_last_played_song_id($v=NULL) {
		$query = 'SELECT last_played_song_id FROM playlists WHERE id = ?';
		return $this->sql->get_row($query, [$v['id']]);
	}

	public function set_last_played_song($v) {
		$insert = $this->statement->generate($v, 'playlists');
		$this->sql->_($insert, $v);
		return ['result' => 1];
	}

	public $media;

	public function set_position($v) {
		$this->media->set_time($v['position']/10000);
		return ['result' => 1];
	}

	public function set_media($v) {
		$query = 'SELECT current_position FROM library WHERE id = ?';
		$row = $this->sql->get_row($query, [$v['id']]);
		if(!$files->exists($v['media_path'])) {
			$row['not_found'] = true;
			return $row;
		}
		$this->make_accessible($v['media_path'], function() {
			$this->media->play($v['media_path'], $v['id']);
		});
		$insert = 'UPDATE library SET last_played = CURRENT_TIMESTAMP WHERE id = ?';
		$this->sql->execute($insert, [$v['id']]);
	
		return $row;
	}

	public function set_volume($v) {
		$this->media->set_volume($v['volume']);
		return ['res' => 1];
	}

	public function play($v=NULL) {
		$this->media->pause();
		return ['res' => 1];
	}

	public function add_to_playlist($v) {
		$query = 'DELETE FROM playlist_songs WHERE playlist_id = ? AND song_id = ?';
		$this->sql->execute($query, [$v['playlist_id'], $v['song_id']]);
		$insert = $this->statement->generate($v, 'playlist_songs');
		$this->sql->_($insert, $v);
		$id = $this->sql->last_insert_id();
		return ['id' => $id];
	}

	public function get_playlist($v) {
		$query = 'SELECT * FROM playlists WHERE id = ?';
		return $this->sql->get_row($query, [$v['id']]);
	}

	public function _numrand($v) {
		$query = 'DELETE FROM numrand';
		$this->sql->execute($query, []);
		$insert = $this->statement->generate($v, 'numrand');
		$this->sql->_($insert, $v);
		$id = $this->sql->last_insert_id();
		return ['id' => $id];
	}

	public function get_state($v) {
		$query = 'SELECT * FROM numrand';
		return $this->sql->get_row($query, []);
	}

	public function set_playlist_order($v) {
		$insert = $this->statement->generate($v, 'playlists');
		$this->sql->_($insert, $v);
		return ['result' => 1];
	}

	public function _playlist($v) {
		$ids = [];
		if($object->isset($v['ids'])) {
			$ids = $v['ids'];
			delete $v['ids'];
			foreach($ids as $id_key => $id) {
				if($id == NULL) {
					delete $ids[$id_key];
				}
			}
			$ids = $object->values($ids);
		}
		$insert = $this->statement->generate($v, 'playlists');
		$this->sql->_($insert, $v);
		$playlist_id = $this->sql->last_insert_id();
		foreach($ids as $id) {
			$this->add_to_playlist(['song_id' => $id, 'playlist_id' => $playlist_id]);
		}
		return ['id' => $playlist_id];
	}

	public function load_playlists($v) {
		$query = 'SELECT * FROM playlists';
		$rows = $this->sql->get_rows($query, []);
		$result = $object->create();
		$result['playlist_orders'] = $object->create(NULL);
		foreach($rows as $row) {
			$query = 'SELECT library.*, playlist_songs.song_order FROM library, playlist_songs WHERE library.id = playlist_songs.song_id AND playlist_songs.playlist_id = ? ORDER BY playlist_songs.song_order ASC';
			$playlist_items = $this->sql->get_rows($query, [$row['id']]);
			$playlist_item_key = 'playlist_'.$row['id'];
			$result[$playlist_item_key] = $playlist_items;
			$result['playlist_orders'][$playlist_item_key] = $row['songs_order'];
		}
		$query = 'SELECT * FROM library';
		$result['playlist_0'] = $this->sql->get_rows($query, []);
		return $result;
	}

	public function get_playlists($v) {
		$query = 'SELECT * FROM playlists';
		return $this->sql->get_rows($query, []);
	}

	public function move_songs($v) {
		$query = 'SELECT library.id FROM library, playlists, playlist_songs WHERE library.id = playlist_songs.song_id AND playlist_songs.playlist_id = playlists.id AND playlists.id = ?';
		$rows = $this->sql->get_rows($query, [$v['playlist_id']]);
		foreach($rows as $row) {
			$this->add_to_playlist(['song_id' => $row['id'], 'playlist_id' => $v['set_playlist_id']]);
		}
		return ['result' => 1];
	}

	public function delete_from_playlist($v) {
		$playlist_id = $v['playlist_id'];
		foreach($v['playlist_songs'] as $song_id) {
			$query = 'DELETE FROM playlist_songs WHERE playlist_id = ? AND song_id = ?';
			$this->sql->execute($query, [$playlist_id, $song_id]);
		}
		return ['result' => 1];
	}

	public function delete_playlist($v) {
		$query = 'DELETE FROM playlists WHERE id = ?';
		$this->sql->execute($query, [$v['id']]);
		return ['result' => 1];
	}

	public function increment_play_count($v=NULL) {
		$query = 'SELECT plays FROM library WHERE id = ?';
		$plays = $this->sql->get_row($query, [$v['id']])['plays'];
		if($plays == NULL) {
			$plays = 0;
		}
		$plays = $plays+1;
		$v['plays'] = $plays;
		$insert = $this->statement->generate($v, 'library');
		$this->sql->_($insert, $v);
		$id = $this->sql->last_insert_id();
		return ['id' => $id];
	}

	public function get_song($v=NULL) {
		$query = 'SELECT * FROM library WHERE id = ?';
		return $this->sql->get_row($query, [$v['id']]);
	}

	public function set_song_item($v) {
		$insert = $this->statement->generate($v['song_item'], 'library');
		$this->sql->_($insert, $v['song_item']);
		return ['result' => 1];
	}

	public function get_settings_values($v=NULL) {
		if($v != NULL && $object->keys($v)->length > 0) {
			$query = 'SELECT * FROM settings WHERE property_name = ?';
			$row = $this->sql->get_row($query, [$v['property_name']]);
			if($object->isset($row['property_value'])) {
				return $row['property_value'];
			}
			return NULL;
		}
		$query = 'SELECT * FROM settings';
		return $this->sql->get_rows($query, []);
	}

	public function set_setting($v) {
		$query = 'DELETE FROM settings WHERE property_name = ?';
		$this->sql->execute($query, [$v['property_name']]);
		$insert = $this->statement->generate($v, 'settings');
		$this->sql->_($insert, $v);
		return ['result' => 1];
	}

	public function choose_downloads_folder($v=NULL) {
		$library_location = $this->get_settings_values(['property_name' => 'downloads_location_input']);
		if($library_location == NULL) {
			$library_location = '/';
		}
		$files->picker($library_location, true, false, function($path) {
			if($files->exists($path) && $files->is_dir($path)) {
				$this->set_setting([
					'property_name' => 'downloads_location_input',
					'property_value' => $path
				]);
				$object->send('app.settings.get_values(data)', ['data' => NULL]);
			} else {
				$object->send('app.loading.invalid_folder(data)', ['data' => 'Invalid folder']);
			}
		});
		return ['result' => 1];
	}

	public function choose_folder($v=NULL) {
		$library_location = $this->get_settings_values(['property_name' => 'library_location_input']);
		if($library_location == NULL) {
			$library_location = '/';
		}
		$files->picker($library_location, true, false, function($path) {
			if($files->exists($path) && $files->is_dir($path)) {
				$this->set_setting([
					'property_name' => 'library_location_input',
					'property_value' => $path
				]);
				$object->send('app.settings.get_values(data)', ['data' => NULL]);
			} else {
				$object->send('app.loading.invalid_folder(data)', ['data' => 'Invalid folder']);
			}
		});
		return ['result' => 1];
	}

	public $extensions = ['wav', 'mp3', 'flac', 'm4a', 'aiff', 'aif'];

	public function recursive_test($v) {
		$result = $this->test_func_a(100);

		$object->log('recursive_test');
		$object->log($result);
		return ['result' => $result];
	}

	public function test_func_a($value) {
		$object->log($value);
		if($value == 0) {
			return 0;
		}
		$this->test_func_a($value-1);
		return ['result' => 1];
	}

	public function make_accessible($path, $callback=NULL) {
		$self = $this;
		if(!$files->is_readable($path)) {
			$picker_callback = function($url) {
				/*$object->log('picker result');
				$object->log($url);
				$object->log($path);*/
				if(!$files->is_readable($path)) {
					$self->access_timeout_counter++;
					$self->make_accessible($callback);
				} else {
					if($callback != NULL) {
						$callback();
					}
				}
			};
			$files->picker($path, true, false, $picker_callback);
		} else {
			if($callback != NULL) {
				$callback();
			}
		}
		return ['result' => 1];
	}

	public $access_timeout_counter = 0;

	public function make_accessible_multiple($paths, $callback=NULL) {
		if($this->access_timeout_counter > 4) {
			$object->send('app.settings.library.index_completed(data)', ['data' => 0]);
			return false;
		}
		$self = $this;

		$path = $object->array_pop($paths);

		$this->make_accessible($path, function() {
			if($paths->length > 0) {
				$this->make_accessible_multiple($paths, $callback);
			} else {
				if($callback != NULL) {
					$callback();
				}
			}
		});
		return ['result' => 1];
	}

	public function index_files($v=NULL) {
		$this->access_timeout_counter = 0;
		$this->base_instance->indexing_in_progress = true;
		$library_location = $this->get_settings_values(['property_name' => 'library_location_input']);
		/*if($library_location == NULL) {
			return ['result' => 0];
		}*/
		$additional_locations = $this->additional_locations->load();
		$self = $this;

		$sql = $this->sql;
		$statement = $this->statement;
		$wrap = async function() {
			$indexing = new indexing($sql, $statement);
			$result = $indexing->index_files($library_location);

			foreach($additional_locations as $additional_location) {
				$library_location = $additional_location['path'];
				$result = $indexing->index_files($library_location, $additional_location['id']);
			}


			$self->base_instance->indexing_in_progress = false;

			$object->send('app.settings.library.index_completed(data)', ['data' => $result]);
		};

		$additional_locations_and_library = $object->map($additional_locations, function($e) {
			return $e['path'];
		});
		if($library_location != NULL) {
			$additional_locations_and_library[] = $library_location;
		}
		
		$this->make_accessible_multiple($additional_locations_and_library, $wrap);
		return ['result' => 0];
	}

	public function login_grant_access($v=NULL) {
		$library_location = $this->get_settings_values(['property_name' => 'library_location_input']);

		$additional_locations = $this->additional_locations->load();


		$additional_locations_and_library = $object->map($additional_locations, function($e) {
			return $e['path'];
		});
		$additional_locations_and_library[] = $library_location;

		$this->make_accessible_multiple($additional_locations_and_library, NULL);

		return true;
	}
	
	public function clean_files($v=NULL) {
		$this->access_timeout_counter = 0;
		$this->base_instance->indexing_in_progress = true;
		$library_location = $this->get_settings_values(['property_name' => 'library_location_input']);
		if($library_location == NULL) {
			return ['result' => 0];
		}
		$additional_locations = $this->additional_locations->load();

		$self = $this;

		$sql = $this->sql;
		$statement = $this->statement;

		$wrap = async function() {
			$indexing = new indexing($sql, $statement);
			$result = $indexing->clean_files($library_location);

			$indexing->clean_lost_locations($additional_locations);

			foreach($additional_locations as $additional_location) {
				$library_location = $additional_location['path'];
				$result = $indexing->clean_files($library_location, $additional_location['id']);
			}


			$object->send('app.settings.library.index_completed(data)', ['data' => $result]);
			$self->base_instance->indexing_in_progress = false;
		};
		$wrap();
		return ['result' => 0];
	}

	

	public function get_playlists_for_song($v) {
		$query = 'SELECT playlist_id FROM playlist_songs WHERE song_id = ?';
		return $this->sql->get_rows($query, [$v['song_id']]);
	}

	public function save_smart_folder($v) {
		$item = $v['item'];
		$insert_data = [
			'name' => $item['name']
		];
		$filter_id = NULL;
		if($object->isset($item['id'])) {
			$insert_data['id'] = $item['id'];
			$filter_id = $item['id'];
		}
		$insert = $this->statement->generate($insert_data, 'filters');
		$this->sql->_($insert, $insert_data);
		if($filter_id == NULL) {
			$filter_id = $this->sql->last_insert_id();
		}
		$query = 'DELETE FROM filter_constraints WHERE filter_id = ?';
		$this->sql->execute($query, [$filter_id]);

		foreach($v['constraints'] as $constraint) {
			$insert = $this->statement->generate($constraint, 'filter_constraints');
			$this->sql->_($insert, $constraint);
		}
		return ['result' => 1];
	}

	public function get_filters($v=NULL) {
		$query = 'SELECT * FROM filters ORDER BY id ASC';
		$rows = $this->sql->get_rows($query, []);
		return $rows;
	}

	public function save_searches($v=NULL) {
		$query = 'DELETE FROM filters';
		$this->sql->execute($query, []);
		foreach($v['saved_searches'] as $saved_search) {
			$insert_data = [
				'name' => $saved_search
			];
			$insert = $this->statement->generate($insert_data, 'filters');
			$this->sql->_($insert, $insert_data);
		}
		return ['result' => 1];
	}

	public function delete_songs($v) {
		foreach($v['playlist_songs'] as $id) {
			$query = 'DELETE FROM library WHERE id = ?';
			$this->sql->execute($query, [$id]);
			$query = 'DELETE FROM playlist_songs WHERE playlist_songs.song_id = ?';
			$this->sql->execute($query, [$id]);
		}
		return ['result' => 1];
	}

	public function save_shuffle_template($v) {
		$insert_data = [
			'tags' => $object->toJSON($v['tags'])
		];
		if($v['id'] != NULL) {
			$insert_data['id'] = $v['id'];
		}

		$insert = $this->statement->generate($insert_data, 'shuffle_templates');
		$this->sql->_($insert, $insert_data);
		$id = $this->sql->last_id($insert_data);
		return ['id' => $id];
	}

	public function get_saved_shuffle_templates($v) {
		$query = 'SELECT * FROM shuffle_templates ORDER BY id DESC';
		return $this->sql->get_rows($query, []);
	}

}

?>
