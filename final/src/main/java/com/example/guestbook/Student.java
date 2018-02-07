/**
 * Copyright 2014-2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//[START all]
package com.example.guestbook;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.lang.String;
import java.util.Date;
import java.util.List;

/**
 * The @Entity tells Objectify about our entity. We also register it in
 * {@link OfyHelper} Our primary key @Id is set automatically by the Google
 * Datastore for us.
 *
 * We add a @Parent to tell the object about its ancestor. We are doing this to
 * support many guestbooks. Objectify, unlike the AppEngine library requires
 * that you specify the fields you want to index using @Index. Only indexing the
 * fields you need can lead to substantial gains in performance -- though if not
 * indexing your data from the start will require indexing it later.
 *
 * NOTE - all the properties are PUBLIC so that we can keep the code simple.
 **/
@Entity
public class Student {
	Key<Tutorial> tutorialToAttend = null;

	@Id public String student_id;
	public String student_name;
	public String student_email;

	/**
	 * Constructor
	 **/
	public Student() {
	}

	public Student(User user) {
		student_id = user.getUserId();
		student_name = user.getNickname();
		student_email = user.getEmail();
	}

	/*
	 * @return 1: if a new student is added
	 * 
	 * @return 0: if the student is already in the database
	 */
	public static int addStudent(User user) {
		Student addedStudent = null;
		Student searchedStudent = ObjectifyService.ofy().load().type(Student.class).id(user.getUserId()).now();
		if (searchedStudent == null) {
			addedStudent = new Student(user);
			ObjectifyService.ofy().save().entity(addedStudent).now();
			return 1;
		} else
			return 0;
	}

	/**
	 * @return null, if student not in Datastore
	 * @return "none", if student not registered to any tutorial
	 * @return TutorialID, if student registered to a tutorial
	 **/
	public static String getStudentsTutorial(User user) {
		Student searchedStudent = ObjectifyService.ofy().load().type(Student.class).id(user.getUserId()).now();

		if (searchedStudent == null) {
			return null;
		} else {
			if (searchedStudent.tutorialToAttend == null)
				return "none";
			else
				return searchedStudent.tutorialToAttend.getName();
		}

	}

	/**
	 * @return 1 If registration successful
	 * @return 0 If registration already done
	 **/
	public static int registerToTutorial(User user, String tutorialID) {
		
		Student searchedStudent = ObjectifyService.ofy().load().type(Student.class).id(user.getUserId()).now();
		
		if (searchedStudent == null) {
			searchedStudent = new Student(user);
			ObjectifyService.ofy().save().entity(searchedStudent).now();
		}

		if (searchedStudent.tutorialToAttend != null)
			return 0;
		else {
			if (tutorialID != null) {
				searchedStudent.tutorialToAttend = Key.create(Tutorial.class, tutorialID);
			} else {
				searchedStudent.tutorialToAttend = Key.create(Tutorial.class, "default");
			}
			ObjectifyService.ofy().save().entity(searchedStudent).now();
			return 1;
		}
	}
	
	// Unregistering student from tutorial
	public static void unregisterFromTutorial(String userId, String tutorialID) {
		
		Student searchedStudent = ObjectifyService.ofy().load().type(Student.class).id(userId).now();

		if (searchedStudent!=null && searchedStudent.tutorialToAttend!=null)
		{
			searchedStudent.tutorialToAttend = null;
			ObjectifyService.ofy().save().entity(searchedStudent).now();
		}
	}

}