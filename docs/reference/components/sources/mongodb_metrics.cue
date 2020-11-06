package metadata

components: sources: mongodb_metrics: {
	title:       "MongoDB Metrics"
	description: "[MongoDB][urls.mongodb] is a general purpose, document-based, distributed database built for modern application developers and for the cloud era."

	classes: {
		commonly_used: false
		delivery:      "at_least_once"
		deployment_roles: ["daemon", "sidecar"]
		development:   "beta"
		egress_method: "batch"
	}

	features: {
		collect: {
			checkpoint: enabled: false
			from: {
				name:     "MongoDB Server"
				thing:    "a \(name)"
				url:      urls.mongodb
				versions: null

				interface: {
					socket: {
						api: {
							title: "MongoDB serverStatus command"
							url:   urls.mongodb_command_server_status
						}
						direction: "outgoing"
						protocols: ["tcp"]
						ssl: "optional"
					}
				}
			}
		}
		multiline: enabled: false
	}

	support: {
		platforms: {
			"aarch64-unknown-linux-gnu":  true
			"aarch64-unknown-linux-musl": true
			"x86_64-apple-darwin":        true
			"x86_64-pc-windows-msv":      true
			"x86_64-unknown-linux-gnu":   true
			"x86_64-unknown-linux-musl":  true
		}

		requirements: [
			"User from endpoint should have enough privileges for running [serverStatus][urls.mongodb_command_server_status] command",
		]

		warnings: []
		notices: []
	}

	configuration: {
		endpoint: {
			description: "MongoDB [Connection String URI Format][urls.mongodb_connection_string_uri_format]"
			required:    true
			type: "string": {
				examples: ["mongodb://localhost:27017"]
			}
		}
		interval_secs: {
			description: "The interval between scrapes."
			common:      true
			required:    false
			type: uint: {
				default: 15
				unit:    "seconds"
			}
		}
		namespace: {
			description: "The namespace of metrics. Disabled if empty."
			common:      false
			required:    false
			type: string: default: "mongodb"
		}
	}

	output: metrics: {
		_endpoint: {
			description: "The absolute path of originating file."
			required:    true
			examples: ["mongodb://localhost:27017"]
		}
		_host: {
			description: "The hostname of the MongoDB server"
			required:    true
			examples: [_values.local_host]
		}
		up: {
			description: "If the MongoDB server is up or not."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		assets_total: {
			description: "Number of assertions raised since the MongoDB process started."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "The assertion type"
					required:    true
					examples: ["regular", "warning", "msg", "user", "rollovers"]
				}
			}
		}
		connections: {
			description: "Number of connections in some state."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				state: {
					description: "The connection state"
					required:    true
					examples: ["active", "available", "current"]
				}
			}
		}
		extra_info_heap_usage_bytes: {
			description:   "The total size in bytes of heap space used by the database process."
			relevant_when: "Unix/Linux"
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		extra_info_page_faults: {
			description: "The total number of page faults."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		instance_local_time: {
			description: "The ISODate representing the current time, according to the server, in UTC."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		instance_uptime_estimate_seconds_total: {
			description: "The uptime in seconds as calculated from MongoDB’s internal course-grained time keeping system."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		instance_uptime_seconds_total: {
			description: "The number of seconds that the current MongoDB process has been active."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		memory: {
			description: "Current memory unsage."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Memory type"
					required:    true
					examples: ["resident", "virtual", "mapped", "mapped_with_journal"]
				}
			}
		}
		mongod_global_lock_total_time_seconds: {
			description: "The time since the database last started and created the globalLock. This is roughly equivalent to total server uptime."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_global_lock_active_clients: {
			description: "Number of connected clients and the read and write operations performed by these clients."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Number type."
					required:    true
					examples: ["total", "readers", "writers"]
				}
			}
		}
		mongod_global_lock_current_queue: {
			description: "Number of operations queued because of a lock."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Number type."
					required:    true
					examples: ["total", "readers", "writers"]
				}
			}
		}
		mongod_locks_time_acquiring_global_seconds_total: {
			description: "Amount of time that any database has spent waiting for the global lock."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Lock type."
					required:    true
					examples: ["ParallelBatchWriterMode", "ReplicationStateTransition", "Global", "Database", "Collection", "Mutex", "Metadata", "oplog"]
				}
				mode: {
					description: "Lock mode."
					required:    true
					examples: ["read", "write"]
				}
			}
		}
		mongod_metrics_cursor_timed_out_total: {
			description: "The total number of cursors that have timed out since the server process started."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_cursor_open: {
			description: "Number of cursors."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				state: {
					description: "Cursor state."
					required:    true
					examples: ["no_timeout", "pinned", "total"]
				}
			}
		}
		mongod_metrics_document_total: {
			description: "Document access and modification patterns."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				state: {
					description: "Document state."
					required:    true
					examples: ["deleted", "inserted", "returned", "updated"]
				}
			}
		}
		mongod_metrics_get_last_error_wtime_num: {
			description: "The total number of getLastError operations with a specified write concern."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_get_last_error_wtime_seconds_total: {
			description: "The total amount of time that the mongod has spent performing getLastError operations."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_get_last_error_wtimeouts_total: {
			description: "The number of times that write concern operations have timed out as a result of the wtimeout threshold to getLastError."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_operation_total: {
			description: "Update and query operations that MongoDB handles using special operation types."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Operation type."
					required:    true
					examples: ["scan_and_order", "write_conflicts"]
				}
			}
		}
		mongod_metrics_query_executor_total: {
			description: "Data from query execution system."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				state: {
					description: "Query state."
					required:    true
					examples: ["scanned", "scanned_objects", "collection_scans"]
				}
			}
		}
		mongod_metrics_record_moves_total: {
			description: "Moves reports the total number of times documents move within the on-disk representation of the MongoDB data set. Documents move as a result of operations that increase the size of the document beyond their allocated record size."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_apply_batches_num_total: {
			description: "The total number of batches applied across all databases."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_apply_batches_seconds_total: {
			description: "The total amount of time the mongod has spent applying operations from the oplog."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_apply_ops_total: {
			description: "The total number of oplog operations applied."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_buffer_count: {
			description: "The current number of operations in the oplog buffer."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_buffer_max_size_bytes_total: {
			description: "The maximum size of the buffer."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_buffer_size_bytes: {
			description: "The current size of the contents of the oplog buffer."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_executor_queue: {
			description: "Number of queued operations in the replication executor."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Queue type."
					required:    true
					examples: ["network_in_progress", "sleepers"]
				}
			}
		}
		mongod_metrics_repl_executor_unsignaled_events: {
			description: "Number of unsignaled events in the replication executor."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_network_bytes_total: {
			description: "The total amount of data read from the replication sync source."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_network_getmores_num_total: {
			description: "The total number of getmore operations, which are operations that request an additional set of operations from the replication sync source."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_network_getmores_seconds_total: {
			description: "The total amount of time required to collect data from getmore operations."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_network_ops_total: {
			description: "The total number of operations read from the replication source."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_repl_network_readers_created_total: {
			description: "The total number of oplog query processes created."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_ttl_deleted_documents_total: {
			description: "The total number of documents deleted from collections with a ttl index."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_metrics_ttl_passes_total: {
			description: "The number of times the background process removes documents from collections with a ttl index."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_op_latencies_histogram: {
			description: "Latency statistics."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Latency type."
					required:    true
					examples: ["reads", "writes", "commands"]
				}
				micros: {
					description: "Bucket."
					required:    true
					examples: ["1", "2", "4096", "16384", "49152"]
				}
			}
		}
		mongod_op_latencies_latency: {
			description: "A 64-bit integer giving the total combined latency in microseconds."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Latency type."
					required:    true
					examples: ["network_in_progress", "sleepers"]
				}
			}
		}
		mongod_op_latencies_ops_total: {
			description: "A 64-bit integer giving the total number of operations performed on the collection since startup."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Latency type."
					required:    true
					examples: ["network_in_progress", "sleepers"]
				}
			}
		}
		mongod_storage_engine: {
			description: "The name of the current storage engine."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				engine: {
					description: "Engine name."
					required:    true
					examples: ["wiredTiger"]
				}
			}
		}
		mongod_wiredtiger_blockmanager_blocks_total: {
			description:   "Statistics on the block manager operations."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Operation type."
					required:    true
					examples: ["blocks_read", "blocks_read_mapped", "blocks_pre_loaded", "blocks_written"]
				}
			}
		}
		mongod_wiredtiger_blockmanager_bytes_total: {
			description:   "Statistics on the block manager operations."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Operation type."
					required:    true
					examples: ["bytes_read", "bytes_read_mapped", "bytes_written"]
				}
			}
		}
		mongod_wiredtiger_cache_bytes: {
			description:   "Statistics on the cache and page evictions from the cache."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Statistics type."
					required:    true
					examples: ["total", "dirty", "internal_pages", "leaf_pages"]
				}
			}
		}
		mongod_wiredtiger_cache_bytes_total: {
			description:   "Statistics on the cache and page evictions from the cache."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Statistics type."
					required:    true
					examples: ["read", "written"]
				}
			}
		}
		mongod_wiredtiger_cache_evicted_total: {
			description:   "Statistics on the cache and page evictions from the cache."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Statistics type."
					required:    true
					examples: ["modified", "unmodified"]
				}
			}
		}
		mongod_wiredtiger_cache_max_bytes: {
			description: "Maximum cache size."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_wiredtiger_cache_overhead_percent: {
			description: "Percentage overhead."
			type:        "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_wiredtiger_cache_pages: {
			description:   "Pages in the cache."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Pages type."
					required:    true
					examples: ["total", "dirty"]
				}
			}
		}
		mongod_wiredtiger_cache_pages_total: {
			description:   "Pages in the cache."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Pages type."
					required:    true
					examples: ["read", "write"]
				}
			}
		}
		mongod_wiredtiger_concurrent_transactions_available_tickets: {
			description:   "Information on the number of concurrent of read and write transactions allowed into the WiredTiger storage engine"
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Transactions type."
					required:    true
					examples: ["read", "write"]
				}
			}
		}
		mongod_wiredtiger_concurrent_transactions_out_tickets: {
			description:   "Information on the number of concurrent of read and write transactions allowed into the WiredTiger storage engine"
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Transactions type."
					required:    true
					examples: ["read", "write"]
				}
			}
		}
		mongod_wiredtiger_concurrent_transactions_total_tickets: {
			description:   "Information on the number of concurrent of read and write transactions allowed into the WiredTiger storage engine"
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Transactions type."
					required:    true
					examples: ["read", "write"]
				}
			}
		}
		mongod_wiredtiger_log_bytes_total: {
			description:   "Statistics on WiredTiger’s write ahead log (i.e. the journal)."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Bytes type."
					required:    true
					examples: ["payload", "written"]
				}
			}
		}
		mongod_wiredtiger_log_operations_total: {
			description:   "Statistics on WiredTiger’s write ahead log (i.e. the journal)."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Operations type."
					required:    true
					examples: ["write", "scan", "scan_double", "sync", "sync_dir", "flush"]
				}
			}
		}
		mongod_wiredtiger_log_records_scanned_total: {
			description:   "Statistics on WiredTiger’s write ahead log (i.e. the journal)."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Scanned records type."
					required:    true
					examples: ["compressed", "uncompressed"]
				}
			}
		}
		mongod_wiredtiger_log_records_total: {
			description:   "Statistics on WiredTiger’s write ahead log (i.e. the journal)."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_wiredtiger_session_open_sessions: {
			description:   "Open session count."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		mongod_wiredtiger_transactions_checkpoint_seconds: {
			description:   "Statistics on transaction checkpoints and operations."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "gauge"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Checkpoint type."
					required:    true
					examples: ["min", "max"]
				}
			}
		}
		mongod_wiredtiger_transactions_checkpoint_seconds_total: {
			description:   "Statistics on transaction checkpoints and operations."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
		}
		mongod_wiredtiger_transactions_running_checkpoints: {
			description:   "Statistics on transaction checkpoints and operations."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
		}
		mongod_wiredtiger_transactions_total: {
			description:   "Statistics on transaction checkpoints and operations."
			relevant_when: "Storage engine is `wiredTiger`."
			type:          "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Transactions type."
					required:    true
					examples: ["begins", "checkpoints", "committed", "rolledback"]
				}
			}
		}
		network_bytes_total: {
			description: "The number of bytes that reflects the amount of network traffic."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				state: {
					description: "Bytes state."
					required:    true
					examples: ["bytes_in", "bytes_out"]
				}
			}
		}
		network_metrics_num_requests_total: {
			description: "The total number of distinct requests that the server has received."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
			}
		}
		op_counters_repl_total: {
			description: "Database replication operations by type since the mongod instance last started."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Counter type."
					required:    true
					examples: ["insert", "query", "update", "delete", "getmore", "command"]
				}
			}
		}
		op_counters_total: {
			description: "Database operations by type since the mongod instance last started."
			type:        "counter"
			tags: {
				endpoint: _endpoint
				host:     _host
				type: {
					description: "Counter type."
					required:    true
					examples: ["insert", "query", "update", "delete", "getmore", "command"]
				}
			}
		}
	}

	how_it_works: {
		mod_status: {
			title: "MongoDB `serverStatus` command"
			body: """
				The [serverStatus][urls.mongodb_command_server_status] command
				returns a document that provides an overview of the database’s
				state. The output fields vary depending on the version of
				MongoDB, underlying operating system platform, the storage
				engine, and the kind of node, including `mongos`, `mongod` or
				`replica set` member.
				"""
		}
	}
}