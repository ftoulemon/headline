#!/usr/bin/env python
# conding: utf-8

import trello

def printTodayBoard():
    """Print the task in the today board"""
    # Get auth info
    with open('auth/trelloApiKey', 'r') as f:
        API_KEY = f.readline().strip()
    with open('auth/trelloToken', 'r') as f:
        API_TOKEN = f.readline().strip()
    # Get boards
    members = trello.Members(API_KEY, API_TOKEN)
    boards = members.get_board('ftoulemon')
    persoBoardId = None
    for board in boards:
        if 'Perso' == board['name']:
            persoBoardId = board['id']
            break;
    if not persoBoardId:
        return
    # list board
    board = trello.Boards(API_KEY, API_TOKEN)
    lists = board.get_list(persoBoardId)
    todayListId = None
    for l in lists:
        if "Today" == l['name']:
            todayListId = l['id']
            break
    if not todayListId:
        return
    todayList = trello.Lists(API_KEY, API_TOKEN)
    tasks = todayList.get_card(todayListId)
    print "A faire:"
    for task in tasks:
        print task['name']

if __name__ == "__main__":
    printTodayBoard()

