# OSRM

Elixir bindings for OSRM REST API.

#### Methods

| Service                              | Description                                               |
| ------------------------------------ | --------------------------------------------------------- |
| [`route`](lib/dispatcher/ride.ex)    | shortest path between given coordinates                   |
| nearest                              | returns the nearest street segment for a given coordinate |
| table                                | computes distance tables for given coordinates            |
| match                                | matches given coordinates to the road network             |
| trip                                 | compute the shortest trip between given coordinates       |
| tile                                 | return vector tiles containing debugging info             |

## Installation

The package can be installed by adding `osrm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:osrm, "~> 0.1.0"}]
end
```

Docs can be found at [https://hexdocs.pm/osrm](https://hexdocs.pm/osrm).
