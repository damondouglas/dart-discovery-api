import 'dart:html';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
import "package:google_oauth2_client/google_oauth2_browser.dart" as oauth;
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_drive_v2_api/drive_v2_api_client.dart" as drivelib_client;
import "package:dda/helloworld_v1_api_client.dart" as helloclient;
import "package:dda/helloworld_v1_api_browser.dart" as hellobrowser;
import 'drive.dart';
import 'dart:mirrors';
import 'dart:js';


final CLIENT_ID = "PUT CLIENT_ID HERE";
final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];

void main() {

	document.body.style
	..fontFamily = "'Montserrat', sans-serif";

	_oauth();
	_insert();
	_load();
	_copy();
	_comments();
	_rev();
	_custom();

	querySelectorAll('button').style
	..border = "0"
	..borderRadius = "5px"
	..height = "50px"
	..width = "125px"
	..fontSize = "20px"
	..color = "white";

	window.onHashChange.listen((e){
		var locn = window.location.href;
		var hashindex = locn.indexOf("#");
		var slideno = int.parse(locn.substring(hashindex+1));

		var slidemap = {
			6: "load",
			7: "copy",
			8: "comments",
			9: "rev"
		};

		var slide = slidemap[slideno];

		if(slide!=null) {
			var button = querySelector(".${slide} button");
			var insert = querySelector(".insert");
			var fileId = insert.dataset['fileid'];
			if(fileId == null) {
				button.disabled = true;
				button.style.backgroundColor = "#5585e6";
			} else {
				button.disabled = false;
				button.style.backgroundColor = "#0000ff";
			}
		}
	});

}

Future <oauth.Token> _getToken() {
	var completer = new Completer();
	var auth = new oauth.GoogleOAuth2(CLIENT_ID, SCOPES);
	if(!window.localStorage.containsKey('token')) {
		auth.login().then((oauth.Token token){
			window.localStorage["token"] = token.toJson();
			completer.complete(token);
		});
	} else {
		Map map = JSON.decode(window.localStorage["token"]);
		var type = map["type"];
		var data = map["data"];
		var expiry = new DateTime.fromMillisecondsSinceEpoch(map['expiry']);
		var token = new oauth.Token(type, data, expiry);
		var request = new HttpRequest();
		request.open("GET", "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$data");
		request.onLoad.listen((e){
			if(request.status == 200) {
				var token = new oauth.Token(type, data, expiry);
				completer.complete(token);
			} else {
				auth.login().then((oauth.Token token){
					completer.complete(token);
				});

			}
		});

		try {
			request.send();
		} catch(e) {
			auth.login().then((oauth.Token token){
				completer.complete(token);
			});
		}
	}
	return completer.future;
}

void _oauth() {
	var oauth = querySelector('.oauth');
	oauth.innerHtml = """
		<button><i class="fa fa-caret-square-o-right"></i> Login</button>
	""";

	var button = querySelector('.oauth button');
	button.style.backgroundColor = "#0000ff";

	button.onClick.listen((e){
		_getToken().then((token){
			button.disabled = true;
			button.style..backgroundColor = "#5585e6";
			print(token);
		});
	});
}

void _insert() {
	var insert = querySelector(".insert");
	var fileId = insert.dataset['fileid'];
	insert.innerHtml = """
		<button><i class="fa fa-file-o"></i> New</button>
		<div></div>
	""";

	var button = insert.querySelector('button');
	button.style.backgroundColor = "#0000ff";
	var div = insert.querySelector('div');
	
	var insertFileDom = (drivelib_client.File file) {
		insert.dataset['fileid'] = file.id;

		var a = new AnchorElement();
		a.href = file.alternateLink;
		a.target = "_blank";

		var img = new ImageElement(src:file.iconLink);
		var span = new SpanElement();
		span.text = file.title;

		a.children.add(img);
		a.children.add(span);

		div.children.add(a);
		button.disabled = true;	
		button.style.backgroundColor = "#5585e6";
	};

	if(fileId != null) {
		button.disabled = true;	
		button.style.backgroundColor = "#5585e6";
		_getToken().then((token){
			get_file(token, fileId).then(insertFileDom);
		});

	}

	div.style
	..marginTop = "50px";

	button.onClick.listen((e){
		_getToken().then((token){
			insert_file(token, "New Document").then(insertFileDom);
		});
	});
}

void _load() {
	var load = querySelector(".load");

	load.innerHtml = """
		<button><i class="fa fa-cloud"></i> Load</button>
		<div></div>
	""";

	var button = load.querySelector('button');
	var div = load.querySelector('div');


	var loadDoc = (drivelib_client.File file) {
		div.text = file.toString();
		div.style
		..marginTop = "50px"
		..border = "1px lightgray solid"
		..borderRadius = "5px"
		..overflow = "scroll"
		..width = "600px"
		..height = "200px";
	};

	button.onClick.listen((e){
		_getToken().then((token){
			var insert = querySelector(".insert");
			var fileId = insert.dataset['fileid'];
			get_file(token, fileId).then(loadDoc);
		});
	});
}

void _copy() {
	var copy = querySelector(".copy");
	
	copy.innerHtml = """
		<button><i class="fa fa-files-o"></i> Copy</button>
		<div></div>
	""";

	var button = copy.querySelector('button');
	var div = copy.querySelector('div');
	div.style.marginTop = "50px";

	button.onClick.listen((e){
		_getToken().then((token){
			var insert = querySelector(".insert");
			var fileId = insert.dataset['fileid'];
			copy_file(token, fileId).then((drivelib_client.File file){
				insert.dataset['fileid'] = file.id;

				var a = new AnchorElement();
				a.href = file.alternateLink;
				a.target = "_blank";

				var img = new ImageElement(src:file.iconLink);
				var span = new SpanElement();
				span.text = file.title;

				a.children.add(img);
				a.children.add(span);

				div.children.add(a);
				button.disabled = true;	
				button.style.backgroundColor = "#5585e6";
			});
		});
	});
}

void _comments() {
	var comments = querySelector(".comments");
	
	comments.innerHtml = """
		<button><i class="fa fa-comments"></i> Comment</button>
		<div></div>
	""";

	var button = comments.querySelector("button");
	var div = comments.querySelector('div');

	button.onClick.listen((e){
		_getToken().then((token){
			var insert = querySelector(".insert");
			var fileId = insert.dataset['fileid'];
			comment_file(token, fileId, "Some Random Comment").then((comment) => window.console.log(comment));
		});
	});
}

void _rev() {
	var rev = querySelector(".rev");
	
	rev.innerHtml = """
		<button><i class="fa fa-list-alt"></i> History</button>
		<div></div>
	""";

	var button = rev.querySelector('button');
	var div = rev.querySelector('div');
	div.style
	..marginTop = "50px";

	var getRevisionText = (String url){
		var completer = new Completer();
		HttpRequest.getString(url).then((data){
			print(data);
			completer.complete(data);
		});
		return completer.future;
	};

	button.onClick.listen((e){
		_getToken().then((token){
			var insert = querySelector(".insert");
			var fileId = insert.dataset['fileid'];
			div.innerHtml = "";

			list_revisions(token, fileId).then((revisions){
				var items = revisions.items;

				items.forEach((rev){
					var d = new DivElement();
					d.innerHtml = "<span>Modified ${rev.modifiedDate} by ${rev.lastModifyingUserName}</span>";
					div.children.add(d);
				});
			});
		});
	});
}

void _custom() {
	var custom = querySelector('.custom');

	custom.innerHtml = """ 
		<button><i class="fa fa-cogs"></i> Custom API</button>
		<div></div>
	""";

	var button = querySelector('.custom button');
	var div = querySelector('.custom div');
	
	div.style.marginTop = "50px";


	button.style.backgroundColor = "#0000ff";

	button.onClick.listen((e){
		div.innerHtml = "";
		var client = new hellobrowser.Helloworld();
		// var r = reflect(client).type;
		// var m = r.declarations;
		// window.console.log(m);
		client.greetings.listGreeting().then((collection){
			collection.items.forEach((greeting){
				window.console.log(greeting);
				var d = new DivElement();
				d.innerHtml = """
					<span><i class="fa fa-cog"></i> ${greeting.message}</span>
				""";
				div.children.add(d);
			});
		});
		// window.console.log(client.greetings);
	});
}


