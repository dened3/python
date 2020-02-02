#!/usr/bin/python3
import json
import os

class teams:
    def __init__(self, team):
        f = open('teams.json')
        teams = json.loads(f.read())

        self.team = teams[team]
        #print(self.team)

        self.user_list_str = ""
        for u in self.team:
            self.user_list_str = self.user_list_str + "'" + str(u) + "',"
        self.user_list_str = self.user_list_str[:-1]

if __name__ == "__main__":
    '''
    f = open('teams.json')
    teams = json.loads(f.read())

    for t in teams['sql']:
        print(teams['sql'][t]['name'])
    '''

    tm = teams('sql')

    print(tm.user_list_str)

    print(tm.team['golcova']['name'])
