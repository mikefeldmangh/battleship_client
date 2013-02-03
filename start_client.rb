require './client_net'
require './cell'
require './battleship_client'
require './smart_battleship_client'
require './random_battleship_client'

url = "localhost:3000/"
user = "Mike"
board = [["","","","","","","","","",""],
             ["","","","","","","","","",""],
             ["","","","","","","","","",""],
             ["","","","","","","","","",""],
             ["",5,5,5,5,5,"","","",""],
             ["",3,3,3,"","",4,4,4,4],
             ["",2,2,"","","","","","",3],
             ["","","","","","","","","",3],
             ["","","","","","","","","",3],
             ["","","","","","","","","",""]]

client1 = SmartBattleshipClient.new url, user, board

user = "Joe"
board = [["",5,"","","","","","","",""],
             ["",5,"","","","","","","",""],
             ["",5,"","","","","","","",""],
             ["",5,"","","","","","","",""],
             ["",5,"","","","","","","",""],
             ["",3,3,3,"","",4,4,4,4],
             ["","",2,"","","","","","",""],
             ["","",2,"","","","","","",""],
             ["","","","","","","",3,3,3],
             ["","","","","","","","","",""]]
             
client2 = RandomBattleshipClient.new url, user, board

sleep 3

playing = true
while playing do
  playing = client1.take_turn
  playing = client2.take_turn
end

