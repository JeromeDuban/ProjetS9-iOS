//
//  ConferenceModelBuilder.swift
//  Projet S9
//
//  Created by Jérémie Foucault on 30/11/2014.
//  Copyright (c) 2014 Jérémie Foucault. All rights reserved.
//

import Foundation


class ConferenceModelBuilder {
    
    class func buildConferenceFromJSON(conferenceJson: JSON) {
        let tracks: [Track]     = self.buildTracksFromJSON(conferenceJson["tracks"])
        let id: Int             = conferenceJson["id"].intValue
        let address: String     = conferenceJson["address"].stringValue
        let title: String       = conferenceJson["title"].stringValue
        let start_day: String   = conferenceJson["start_day"].stringValue
        let end_day: String     = conferenceJson["end_day"].stringValue
        let major: Int          = conferenceJson["major"].intValue
        let created_at: Int     = conferenceJson["created_at"].intValue
        let updated_at: Int     = conferenceJson["updated_at"].intValue
        
        
        Conference.sharedInstance.setData(
            id,
            address: address,
            title: title,
            start_day: start_day,
            end_day: end_day,
            major: major,
            created_at: created_at,
            updated_at: updated_at,
            tracks: tracks
        )
    }
    
    class func buildTracksFromJSON(tracksJson: JSON) -> [Track] {
        var tracks: [Track] = [];
        
        for (index, trackJson) in tracksJson {
            let id : Int            = trackJson["id"].intValue
            let title: String       = trackJson["title"].stringValue
            let sessions: [Session] = self.buildSessionsFromJSON(trackJson["sessions"])
            
            tracks.append(Track(id: id, title: title, sessions: sessions))
    
        }
        
        return tracks
    }
    
    class func buildSessionsFromJSON(sessionsJson: JSON) -> [Session] {
        var sessions: [Session] = [];
        
        for (index, sessionJson) in sessionsJson {
            let id: Int         = sessionJson["id"].intValue
            let start_ts: Int   = sessionJson["start_ts"].intValue
            let end_ts: Int     = sessionJson["end_ts"].intValue
            let room_id: Int    = sessionJson["room_id"].intValue
            let talks: [Talk]   = self.buildTalksFromJSON(sessionJson["talks"])
            
            sessions.append(Session(id: id, start_ts: start_ts, end_ts: end_ts, room_id: room_id, talks: talks))
            
        }
        
        return sessions
    }
    
    
    
    class func buildTalksFromJSON(talksJson: JSON) -> [Talk] {
        var talks: [Talk] = [];
        
        for (index, talkJson) in talksJson {
            let id: Int             = talkJson["id"].intValue
            let title: String       = talkJson["title"].stringValue
            let start_ts: Int       = talkJson["start_ts"].intValue
            let end_ts: Int         = talkJson["end_ts"].intValue
            let speaker: String     = talkJson["speaker"].stringValue
            let abstract: String    = talkJson["abstract"].stringValue
            let body: String        = talkJson["body"].stringValue
            
            talks.append(Talk(
                id: id,
                title: title,
                start_ts: start_ts,
                end_ts: end_ts,
                speaker: speaker,
                abstract: abstract,
                body: body))
        }
        
        
        return talks
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}