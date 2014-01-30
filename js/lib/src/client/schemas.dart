part of helloworld_v1_api;

/** Greeting that stores a message. */
class HelloGreeting {

  core.String message;

  /** Create new HelloGreeting from JSON data */
  HelloGreeting.fromJson(core.Map json) {
    if (json.containsKey("message")) {
      message = json["message"];
    }
  }

  /** Create JSON Object for HelloGreeting */
  core.Map toJson() {
    var output = new core.Map();

    if (message != null) {
      output["message"] = message;
    }

    return output;
  }

  /** Return String representation of HelloGreeting */
  core.String toString() => JSON.encode(this.toJson());

}

/** Collection of Greetings. */
class HelloGreetingCollection {

  /** Greeting that stores a message. */
  core.List<HelloGreeting> items;

  /** Create new HelloGreetingCollection from JSON data */
  HelloGreetingCollection.fromJson(core.Map json) {
    if (json.containsKey("items")) {
      items = json["items"].map((itemsItem) => new HelloGreeting.fromJson(itemsItem)).toList();
    }
  }

  /** Create JSON Object for HelloGreetingCollection */
  core.Map toJson() {
    var output = new core.Map();

    if (items != null) {
      output["items"] = items.map((itemsItem) => itemsItem.toJson()).toList();
    }

    return output;
  }

  /** Return String representation of HelloGreetingCollection */
  core.String toString() => JSON.encode(this.toJson());

}

core.Map _mapMap(core.Map source, [core.Object convert(core.Object source) = null]) {
  assert(source != null);
  var result = new dart_collection.LinkedHashMap();
  source.forEach((core.String key, value) {
    assert(key != null);
    if(convert == null) {
      result[key] = value;
    } else {
      result[key] = convert(value);
    }
  });
  return result;
}
