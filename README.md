## nginx-gosted  
This is a docker image based on Nginx with OpenSSL and GOST engine which supports the Russian ГОСТ crypto algorithms. 


![alt text](https://img.shields.io/badge/OpenSSL-GOSTengine-blue.svg 'openssl and gost engine included')
![alt text](https://img.shields.io/badge/NGINX-1.15.7-blue.svg 'based on nginx:latest docker image')
![alt text](https://img.shields.io/badge/ГОСТ-2012-green.svg 'openssl ciphers:GOST2012-GOST8912-GOST8912')
![alt text](https://img.shields.io/badge/ГОСТ-2001-red.svg 'openssl ciphers:GOST2001-GOST89-GOST89 for compatibility')

---
   
   run the container and issue some commands to check that the (gost) engine is enabled and GOST ciphers supported:
```bash
 docker run --rm -i netskol/nginx-gosted openssl engine
 docker run --rm -i netskol/nginx-gosted openssl ciphers |tr ":" "\n"| grep GOST
```  
GOST2012-GOST8912-GOST8912  
GOST2001-GOST89-GOST89  

## Usage Example
Edit docker-compose YAML file according to your needs and start the project:
```bash
docker-compose up -d
```

Images tagged latest and 1.19.6 tested with CryptoPro 5.0 ,so far only tls1.0 works. 
Images from the branch based2018 tested with CryptoPro 5.0 and tls1-tls1.2 works.
