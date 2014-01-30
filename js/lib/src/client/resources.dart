part of helloworld_v1_api;

class GreetingsResource_ {

  final Client _client;

  GreetingsResource_(Client client) :
      _client = client;

  /**
   *
   * [id]
   *
   * [optParams] - Additional query parameters
   */
  async.Future<HelloGreeting> getGreeting(core.int id, {core.Map optParams}) {
    var url = "hellogreeting/{id}";
    var urlParams = new core.Map();
    var queryParams = new core.Map();

    var paramErrors = new core.List();
    if (id == null) paramErrors.add("id is required");
    if (id != null) urlParams["id"] = id;
    if (optParams != null) {
      optParams.forEach((key, value) {
        if (value != null && queryParams[key] == null) {
          queryParams[key] = value;
        }
      });
    }

    if (!paramErrors.isEmpty) {
      throw new core.ArgumentError(paramErrors.join(" / "));
    }

    var response;
    response = _client.request(url, "GET", urlParams: urlParams, queryParams: queryParams);
    return response
      .then((data) => new HelloGreeting.fromJson(data));
  }

  /**
   *
   * [optParams] - Additional query parameters
   */
  async.Future<HelloGreetingCollection> listGreeting({core.Map optParams}) {
    var url = "hellogreeting";
    var urlParams = new core.Map();
    var queryParams = new core.Map();

    var paramErrors = new core.List();
    if (optParams != null) {
      optParams.forEach((key, value) {
        if (value != null && queryParams[key] == null) {
          queryParams[key] = value;
        }
      });
    }

    if (!paramErrors.isEmpty) {
      throw new core.ArgumentError(paramErrors.join(" / "));
    }

    var response;
    response = _client.request(url, "GET", urlParams: urlParams, queryParams: queryParams);
    return response
      .then((data) => new HelloGreetingCollection.fromJson(data));
  }
}

