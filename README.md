# IrbRemote
Inspired by [pry-remote](https://github.com/Mon-Ouie/pry-remote) and [irb_remote](https://github.com/iguchi1124/irb_remote).  
IrbRemote is a Gem that allows the Irb session of a remote process to be manipulated using the local process's Reline. It uses druby for inter-process communication.
![image](https://github.com/QWYNG/irb-remote/assets/16704596/0651b6f8-75aa-4271-91cb-b714c26a580b)

## Caution
This gem is still in development and may not work as expected. Please use it with caution.

## Installation

```
gem install irb-remote
```
## Usage

```bash
-> cat example.rb
require 'irb-remote'
x = 1
y = 'hello'
check_completion = 'success'

binding.irb_remote

puts "#{x} #{y} #{check_completion}"

-> ruby example.rb
[irb-remote] Waiting for client on druby://127.0.0.1:9876
```

in another terminal
```bash
-> irb-remote
Connected to remote session on druby://127.0.0.1:9876

From: sample/sample.rb @ line 8 :

    3: require_relative '../lib/irb-remote'
    4: x = 1
    5: y = 'hello'
    6: check_completion = 'success'
    7:
 => 8: binding.irb_remote
    9:
    10: puts "#{x} #{y} #{check_completion}"

irb-remote>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/QWYNG/irb-remote. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/QWYNG/irb-remote/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the IrbRemote project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/QWYNG/irb-remote/blob/main/CODE_OF_CONDUCT.md).
