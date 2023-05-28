# pass

Store encrypted passwords in a local SQLite database

## Installation

#### SQLite
```sql
CREATE TABLE IF NOT EXISTS "data" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  "name"	    TEXT NOT NULL,
  "username"	TEXT NOT NULL,
  "password"	TEXT NOT NULL,
  "tag"	        TEXT NOT NULL DEFAULT '',
  "created_at"	TEXT NOT NULL DEFAULT '',
  "updated_at"	TEXT NOT NULL DEFAULT ''
);
```

#### Crystal
```crystal
shards install
crystal build src/pass.cr --release
```

## Usage

Add record
```bash
./pass --add --name=Gmail --username=pass_store@gmail.com --password=123ABC --tag=Google
```

Update a record
```bash
./pass --update --id=1 --name=Email --username=pass@gmail.com --password=ABC123 --tag=Gmail
```

Remove a record
```bash
./pass --remove --id=1
```

Search all records
```bash
./pass --search --all
```

Search by id
```bash
./pass --search --id=1
```

Search by name
```bash
./pass --search --name=Email
```

Search by username
```bash
./pass --search --username=pass@gmail.com
```

Search by tag
```bash
./pass --search --tag=Gmail
```

## Contributing

1. Fork it (<https://github.com/xtokio/pass/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [xtokio](https://github.com/xtokio) - creator and maintainer
