# Directions

## Build Image

- `docker build -t smartertech .`

## Run Tests

- Run tests: `docker run --rm smartertech bundle exec rspec`

## Open REPL

- `docker run -it --rm smartertech irb -r ./lib/main.rb`

Examples to try in IRB

- sort(10, 10, 10, 5)    # => "STANDARD"
- sort(10, 10, 10, 20)   # => "SPECIAL"
- sort(100, 100, 100, 20) # => "REJECTED"
