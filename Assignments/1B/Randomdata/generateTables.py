# python3 generateTables.py 4000
import pandas as pd
import numpy as np
from random import randint
import names
from random import seed
from random import random
import sys

seed(1)



places = ["Ylöjärvi", "Ylivieska", "Virrat", "Viitasaari", "Varkaus", "Vantaa", "Valkeakoski", "Vaasa", "Uusikaupunki", "Uusikaarlepyy", "Ulvila", "Turku", "Tornio", "Tampere", "Suonenjoki", "Somero", "Seinäjoki", "Savonlinna", "Sastamala", "Salo", "Saarijärvi", "Rovaniemi", "Riihimäki", "Rauma", "Raisio", "Raasepori", "Raahe", "Pyhäjärvi", "Pudasjärvi", "Porvoo", "Pori", "Pietarsaari", "Pieksämäki", "Parkano", "Parainen", "Paimio", "Outokumpu", "Oulu", "Oulainen", "Orivesi", "Orimattila", "Nurmes", "Nokia", "Nivala", "Närpiö", "Naantali", "Mikkeli", "Mänttä", "Maarianhamina", "Loviisa", "Loimaa", "Lohja", "Lieksa", "Lapua", "Lappeenranta", "Laitila", "Lahti", "Kuusamo", "Kurikka", "Kuopio", "Kuhmo", "Kristiinankaupunki", "Kouvola", "Kotka", "Kokkola", "Kokemäki", "Kiuruvesi", "Kitee", "Keuruu", "Kerava", "Kemijärvi", "Kemi", "Kauniainen", "Kauhava", "Kauhajoki", "Kaskinen", "Karkkila", "Kannus", "Kankaanpää", "Kangasala", "Kalajoki", "Kajaani", "Kaarina", "Jyväskylä", "Joensuu", "Järvenpää", "Jämsä ", "Imatra", "Ikaalinen ", "Iisalmi ", "Hyvinkää", "Huittinen ", "Helsinki ", "Heinola ", "Harjavalta", "Hanko ", "Hamina ", "Hämeenlinna ", "Haapavesi", "Haapajärvi ", "Forssa ", "Espoo ", "Alavus ", "Alajärvi ", "Akaa ", "Ähtäri ", "Äänekoski "]
def getPlace():
  global places
  return(places[randint(0,len(places)-1)])


def getUsers(noOfusers):
  data =  [ [i+1,names.get_full_name(),getPlace()]  for i in range(noOfusers)]
  userdetails = pd.DataFrame(data, columns = ['userid', 'username','places'])
  return(userdetails)

def getedges(noOfusers):
  data = []
  data2 = []
  for i in range(1,noOfusers+1):
    if random() < 0.5:
      continue
    edges = []
    blocks = []
    for j in range(i+1,noOfusers+1):
      if random() > 0.8:
        edges.append([i,j])
      elif random() > 0.94:
        blocks.append([i,j])
    data = data + edges
    data2 = data2 + blocks

  friendlist = pd.DataFrame(data, columns = ['userid1','userid2'])
  block = pd.DataFrame(data2, columns = ['userid1','userid2'])
  return(friendlist,block)


noOfusers =  int(sys.argv[1])
userdetails = getUsers(noOfusers)
friendlist,block = getedges(noOfusers)

userdetails.to_csv('userdetails.csv',index=False,sep = '|') 
friendlist.to_csv('friendlist.csv',index=False,sep = '|')
block.to_csv('block.csv',index=False,sep = '|')



  



