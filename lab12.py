import requests

url = 'http://DESKTOP-E91KERK/fmedatadownload/Dashboards/laby10.fmw?email=scoorabartek%40gmail.com&haslo=sssss&email_klienta=scoorabartek%40gmail.com&nazwa_powiatu=Krak%C3%B3w&pokrycie_chmurami=50&data_poczatek=20230701000000&data_koncowa=20230730000000&API_key=eb2a8c93-225a-4c35-8fb9-cf3b056b0f34&SourceDataset_SHAPEFILE=D%3A%5Cbaza(danych)%5Clab10%5Cpowiaty.shp&DestDataset_GEOTIFF=D%3A%5Cbaza(danych)%5Clab10&opt_showresult=false&opt_servicemode=sync'
myobj = {'Authorization': 'fmetoken token=3127b202824fe6acac9445f527898670ecc96fb0'}

x = requests.post(url, headers=myobj)

print(x.text)