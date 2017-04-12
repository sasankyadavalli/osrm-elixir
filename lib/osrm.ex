defmodule OSRM do
  @moduledoc """
  Provides bindings for OSRM REST API.
  """

  @base_url :osrm |> Application.fetch_env!(__MODULE__) |> Keyword.get(:server_url)
  @version  :osrm |> Application.fetch_env!(__MODULE__) |> Keyword.get(:version, "v1")
  @profile  :osrm |> Application.fetch_env!(__MODULE__) |> Keyword.get(:profile, "car")

  defp coordinate_to_string([lng, lat]) do
    "#{lng},#{lat}"
  end

  defp coordinates_to_string(coordinates) do
    coordinates
    |> Enum.map(&coordinate_to_string/1)
    |> Enum.join(";")
  end

  defp format_url(service, coordinates) do
    "#{@base_url}/#{service}/#{@version}/#{@profile}/" <> coordinates_to_string(coordinates)
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Poison.decode!(body)}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: _, body: body}}) do
    {:ok, body |> Poison.decode!() |> Map.get("message")}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  @doc """
  Fastest route between coordinates in the given order.

  In addition to the general options the following options are supported for this service:
  * `alternatives`        - Search for alternative routes and return as well. Default is `false`
  * `steps`               - Return route steps for each route leg. Default is `false`
  * `annotations`         - Returns additional metadata for each coordinate along the route geometry. Default is `false`
  * `geometries`          - Returned route geometry format. Default is `polyline`
  * `overview`            - Add overview geometry either full, simplified according to highest zoom level it could be display on, or not at all. Default is `simplified`
  * `continue _ straight` - Forces the route to keep going straight at waypoints constraining uturns there even if it would be faster. Default value depends on the profile

  Returns `{:ok, result}` on success, else returns `{:error, reason}`

  ## Examples

      iex> coordinates = [[78.3489, 17.4401], [78.3762, 17.4474], [78.3915, 17.4483]]
      [[78.3489, 17.4401], [78.3762, 17.4474], [78.3915, 17.4483]]
      iex> OSRM.route(coordinates)
      {:ok,
       %{"code" => "Ok",
         "routes" => [%{"distance" => 8397.2, "duration" => 874.2,
            "geometry" => "wgmiBgoe}MaW_M{EaJjH_KrKq[tOc[|QaUuEwDlC{DoBwE_G}DsIwB_@j@eMa@lCaLhIoOLqBc]A}Hq@eDwA}A|HeBjJnGo@xCwOeFaBcHyEuKwBkF}HcGmFzDcy@T?M~B`V_B",
            "legs" => [%{"distance" => 5277.5, "duration" => 507.8, "steps" => [],
               "summary" => "", "weight" => 507.8},
             %{"distance" => 3119.7, "duration" => 366.4, "steps" => [],
               "summary" => "", "weight" => 366.4}], "weight" => 874.2,
            "weight_name" => "routability"}],
         "waypoints" => [%{"hint" => "yXIegP___390fgAASgAAAFcAAAAAAAAAAAAAAEoAAABXAAAAAAAAAAAAAADJ_QYAnQEAACmCqwR8HQoBZIKrBGQdCgEAAAEB4TCUzQ==",
            "location" => [78.348841, 17.440124], "name" => "ISB Road"},
         %{"hint" => "hq9XgP___38AAAAAcwAAAF8BAAAAAAAAAAAAAHMAAABfAQAAAAAAAAAAAAD-qi4AnQEAABvtqwQkOgoBCO2rBOg5CgEAAAEB4TCUzQ==",
           "location" => [78.376219, 17.44746], "name" => ""},
         %{"hint" => "vG4KgMRuCoAAAAAApAAAADAAAAAAAAAAAAAAAKQAAAAwAAAAAAAAAAAAAAAV_gYAnQEAAHcorARkPQoBzCisBGw9CgEAAAEB4TCUzQ==",
           "location" => [78.391415, 17.448292], "name" => ""}]}}


  """
  def route(coordinates, options \\ []) do
    endpoint = format_url("route", coordinates)

    endpoint
    |> HTTPoison.get([], [params: Enum.into(options, %{})])
    |> parse_response()
  end
end
