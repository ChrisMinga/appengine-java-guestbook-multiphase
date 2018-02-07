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

import java.util.Date;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

/**
 * The @Entity tells Objectify about our entity.  We also register it in
 * OfyHelper.java -- very important.
 *
 * This is never actually created, but gives a hint to Objectify about our Ancestor key.
 */
@Entity
public class Tutorial {
  @Id public Long id;
  
  public String identifier; 
  public String tutor;
  public String time;
  public String day;
  public String place;
  
  public Tutorial() {
	  	this("standard", "Pretschner", "10:00", "Monday", "00.08.059");
  }
  
  public Tutorial(String m_id, String m_tutor, String m_time, String m_day, String m_place) {
	  	identifier = m_id;
	    tutor = m_tutor;
	    time = m_time;
	    day = m_day;
	    place = m_place;
  }
}
//[END all]
