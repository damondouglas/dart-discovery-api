import 'dart:async';
import 'dart:html';
import 'package:google_drive_v2_api/drive_v2_api_client.dart' as drivelib;
import 'package:google_drive_v2_api/drive_v2_api_browser.dart' show Drive;
import 'package:google_oauth2_client/google_oauth2_browser.dart' as oauth;

Future <drivelib.File> get_file(oauth.Token token, String fileId) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  drive.files.get(fileId).then((drivelib.File rtrvdFile){
    completer.complete(rtrvdFile);
  });
  return completer.future;
}

Future <drivelib.File> insert_file(oauth.Token token, String fileName) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  var body = {
              'title': fileName,
              'mimeType': "application/vnd.google-apps.document"
  };
  drivelib.File file = new drivelib.File.fromJson(body);
  drive.files.insert(file).then((drivelib.File newFile){
    completer.complete(newFile);
  });
  return completer.future;
}

Future <drivelib.File> copy_file(oauth.Token token, String fileId) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  drive.files.get(fileId).then((drivelib.File rtrvdFile){
    drive.files.copy(rtrvdFile, fileId).then((drivelib.File copiedFile){
      completer.complete(copiedFile);
    });
  });
  return completer.future;
}

Future <Map> delete_file(oauth.Token token, String fileId, DivElement warningTarget) {
  var completer = new Completer();
  warningTarget.innerHtml = "<div><span>CAREFUL: Are you sure you want to delete this?</span><button id='yes'>Yes</button><button id='no'>No</button></div>";
  ButtonElement yesBtn = warningTarget.querySelector('#yes');
  ButtonElement noBtn = warningTarget.querySelector('#no');
  yesBtn.onClick.listen((e){
    var auth = new oauth.SimpleOAuth2(token.data);
    var drive = new Drive(auth);
    drive.makeAuthRequests = true;
    drive.files.delete(fileId).then((deletedFile){
      completer.complete(deletedFile);
    });
  });
  
  noBtn.onClick.listen((e){
    warningTarget.innerHtml = "";
  });
  return completer.future;
}

Future <drivelib.File> patch_file(oauth.Token token, String fileId, String fileName) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  var body = {
              'title': fileName,
              'mimeType': "application/vnd.google-apps.document"
  };
  drivelib.File file = new drivelib.File.fromJson(body);
  drive.files.patch(file, fileId).then((drivelib.File patchedFile){
    completer.complete(patchedFile);
  });
  return completer.future;
}

Future <drivelib.FileList> list_files(oauth.Token token, String query){
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  drive.files.list(maxResults:10,q:query).then((drivelib.FileList fileList){
    completer.complete(fileList);
  });
  return completer.future;
}

Future <drivelib.File>  touch_file(oauth.Token token, String fileId) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  drive.files.touch(fileId).then((drivelib.File touchedFile){
    completer.complete(touchedFile);
  });
  return completer.future;
}

Future <drivelib.File> trash_file(oauth.Token token, String fileId) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  
  drive.files.trash(fileId).then((drivelib.File trashedFile){
    completer.complete(trashedFile);
  });
  
  return completer.future;
}

Future <drivelib.File> untrash_file(oauth.Token token, String fileId) {
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  drive.files.untrash(fileId).then((drivelib.File untrashedFile){
    completer.complete(untrashedFile);
  });
  return completer.future;
}

Future <drivelib.File> update_file(oauth.Token token, String fileId, String content){
  String base64content = window.btoa(content);
  var completer = new Completer();
  var auth = new oauth.SimpleOAuth2(token.data);
  var drive = new Drive(auth);
  drive.makeAuthRequests = true;
  drive.files.get(fileId).then((drivelib.File rtrvdFile){
    drive.files.update(rtrvdFile, fileId, content:base64content).then((drivelib.File updatedFile){
      completer.complete(updatedFile);
    });
  });
  return completer.future;
}

Future<drivelib.Comments> comment_file(oauth.Token token, String fileId, String content) {
	var completer = new Completer();
	var auth = new oauth.SimpleOAuth2(token.data);
	var drive = new Drive(auth);
	drive.makeAuthRequests = true;
	

	drive.files.get(fileId).then((drivelib.File rtrvdFile){
  		var comment = new drivelib.Comment.fromJson({'content':content});
  		drive.comments.insert(comment, rtrvdFile.id).then((drivelib.Comment comment){
  			completer.complete(comment);
  		});
  	});
  	return completer.future;
}

Future<drivelib.RevisionList> list_revisions(oauth.Token token, String fileId) {
	var completer = new Completer();
	var auth = new oauth.SimpleOAuth2(token.data);
	var drive = new Drive(auth);
	drive.makeAuthRequests = true;

	drive.files.get(fileId).then((drivelib.File rtrvdFile){
		drive.revisions.list(rtrvdFile.id).then((revisions){
			completer.complete(revisions);
		});
	});
	return completer.future;
}

Future<drivelib.Revision> get_revision(oauth.Token token, String fileId, String revisionId) {
	var completer = new Completer();
	var auth = new oauth.SimpleOAuth2(token.data);
	var drive = new Drive(auth);
	drive.makeAuthRequests = true;

	return drive.revisions.get(fileId, revisionId);
}

