
POST _template/testing_xrootd
{
    "order" : 0,
    "index_patterns" : [
      "testing_xrootd"
    ],
    "settings" : {
      "index" : {
        "number_of_shards" : "2",
        "number_of_replicas" : "1"
      }
    },
    "mappings" : {
      "docs" : {
        "properties" : {
          "endpoint" : {
            "type" : "keyword"
          },
          "issues" : {
            "type" : "keyword"
          },
          "path" : {
            "type" : "keyword"
          },
          "site" : {
            "type" : "keyword"
          },
          "state" : {
            "type" : "keyword"
          },
          "timestamp" : {
            "type" : "date",
            "format" : "basic_date_time_no_millis"
          }
        }
      }
    },
    "aliases" : { }
  }