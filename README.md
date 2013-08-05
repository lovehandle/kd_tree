# KDTree

KDTree is a Ruby wrapper for John Tsiombikas' KDTree library written in C. It supports K dimensional tree nearest neighbor searches.

## Installation

Add this line to your application's Gemfile:

    gem 'kd_tree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kd_tree

## Usage

Iniitalize a new KDTree with a multi-dimensional array of nodes, and an integer specifying how many dimensions each node has:

```ruby
tree = KDTree.new([ [1, 2, 3], [ 4, 5, 6] ], 3)
#=> #<KDTree:0x007ffca8568748> 
```

Insert additional nodes:

```ruby
tree.insert([7, 8, 9])
#=> [ 7, 8, 9 ]
```

Perform a nearest neighbor search:

```ruby
tree.nearest_neighbor([ 1, 2, 3 ])
#=> { "query"=>[1, 2, 3], "position"=>[1.0, 2.0, 3.0], "distance"=>0.0 }

tree.nearest_neighbor([ 4, 5, 6])
#=> { "query"=>[4, 5, 6], "position"=>[4.0, 5.0, 6.0], "distance"=>0.0 }

tree.nearest_neigbor([ 100, 101, 102 ])
#=> { "query"=>[100, 101, 102], "position"=>[4.0, 5.0, 6.0], "distance"=>27648.0 }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
