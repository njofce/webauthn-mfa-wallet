#//********************************************************************************************/
#//  ___           _       ___               _         _    _ _    
#// | __| _ ___ __| |_    / __|_ _ _  _ _ __| |_ ___  | |  (_) |__ 
#// | _| '_/ -_|_-< ' \  | (__| '_| || | '_ \  _/ _ \ | |__| | '_ \
#// |_||_| \___/__/_||_|  \___|_|  \_, | .__/\__\___/ |____|_|_.__/
#//                                |__/|_|                        
#///* Copyright (C) 2022 - Renaud Dubois - This file is part of FCL (Fresh CryptoLib) project */
#///* License: This software is licensed under MIT License 	 */
#///* See LICENSE file at the root folder of the project.				 */
#///* FILE: FCL_ecdsa_precompute.sage						         */
#///* 											 */
#///* 											 */
#///* DESCRIPTION: precompute a 8 dimensional table for Shamir's trick from a public key
#///* 
#//**************************************************************************************/



def Init_Curve(curve_characteristic,curve_a, curve_b,Gx, Gy, curve_Order):    
	Fp=GF(curve_characteristic); 				#Initialize Prime field of Point
	Fq=GF(curve_Order);					#Initialize Prime field of scalars
	Curve=EllipticCurve(Fp, [curve_a, curve_b]);		#Initialize Elliptic curve
	curve_Generator=Curve([Gx, Gy]);
	
	return [Curve,curve_Generator];


#//initialize elliptic curve , short weierstrass form	
def FCL_ec_Init_Curve(curve_characteristic,curve_a, curve_b,Gx, Gy, curve_Order):    
	Fp=GF(curve_characteristic); 				#Initialize Prime field of Point
	Fq=GF(curve_Order);					#Initialize Prime field of scalars
	Curve=EllipticCurve(Fp, [curve_a, curve_b]);		#Initialize Elliptic curve
	curve_Generator=Curve([Gx, Gy]);
	
	return [Curve,curve_Generator];



#//decompress even y from x value to point (x,y)    
def FCL_ec_decompress_even(curve, pubkey_x):    
  y2=pubkey_x**3+ curve.a4()*pubkey_x+curve.a6();
  y=sqrt(y2);
  if (int(y)%2):
   return -y;
  return y;	
  

#//decompress even y from x value to point (x,y)    
def FCL_ec_decompress(curve, pubkey_x, parity):    
  y2=pubkey_x**3+ curve.a4()*pubkey_x+curve.a6();
  y=sqrt(y2);
 
  if ((int(y)%2)!=parity):
   return -y;
  return y;	
    

#//Curve secp256r1, aka p256	
#//curve prime field modulus
sec256p_p = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF;
#//short weierstrass first coefficient (=a4 in sage)
sec256p_a =0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC;
#//short weierstrass second coefficient    
sec256p_b =0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B;
#//generating point affine coordinates  (=a6 in sage)  
sec256p_gx =0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296;
sec256p_gy =0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5;
#//curve order (number of points)
sec256p_n =0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551;    	



#//Curve secp256k1, aka bitcoin curve, aka ethereum curve
sec256k_p=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
sec256k_a=0;
sec256k_b=7;
sec256k_gx=0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798 ;
sec256k_gy=0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
sec256k_n=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;


#//echo "itsakindofmagic" | sha256sum, used as a label 
_MAGIC_ENCODING=0x9a8295d6f225e4f07313e2e1440ab76e26d4c6ed2d1eb4cbaa84827c8b7caa8d;
	
#//Curve secp256r1, aka p256	
#//curve prime field modulus
sec256p_p = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF;
#//short weierstrass first coefficient
sec256p_a =0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC;
#//short weierstrass second coefficient    
sec256p_b =0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B;
#//generating point affine coordinates    
sec256p_gx =0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296;
sec256p_gy =0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5;
#//curve order (number of points)
sec256p_n =0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551;    	

#//Init    
secp256r1, G = Init_Curve(sec256p_p, sec256p_a, sec256p_b, sec256p_gx, sec256p_gy, sec256p_n);


#//example public point from webauthn.js
Q=secp256r1([C0,C1]);
   
def Precompute_Pubkey(Q, Curve):
      Pow64_PQ=[ Q for i in range(0,16)];
      Prec=[ Curve(0) for i in range(0,256)];


      Pow64_PQ[0]=Curve([sec256p_gx, sec256p_gy]);   
      Pow64_PQ[4]=Q;
     
      for j in [1..3]:
        Pow64_PQ[j]=2^64*Pow64_PQ[j-1];
        Pow64_PQ[j+4]=2^64*Pow64_PQ[j+3];
    
      Prec[0]=Curve(0);
       
      for i in range(1,256):
        Prec[i]=Curve(0);
        for j in [0..7]:
          if( (i&(1<<j))!=0):
            (Prec[i])=(Pow64_PQ[j]+ Prec[i]);
        	
      return Prec;
     
Prec=Precompute_Pubkey(Q, secp256r1);

def print_setlength(X,n):
  l=str(hex(X))[2:];
  s=len(l);
  res="";
  for i in [1..n-s]:
    res=res+"0";
  res=res+l;  
  return res;  

#print for js file 
def Print_Table_js( Q, Curve):
 C_filepath=FILE_NAME + '.js';
 filep = open(C_filepath,'a');

 Prec=Precompute_Pubkey(Q, Curve);
 chain="const precompute=\"0x";
 
  
 for i in [0..255]:
   px=print_setlength( Prec[i][0], 64);
   py=print_setlength( Prec[i][1], 64);
   #print("\n -- \n px=", px, "\n py=",py );
   chain=chain+px+py;
   
 chain=chain+"\"\n exports.precompute=precompute;')";

 filep.write(chain);
 filep.close();

 return 0;

def Print_Table_json( Q, Curve):
 C_filepath=FILE_NAME+'.json';
 filep = open(C_filepath,'w');
 
 Prec=Precompute_Pubkey(Q, Curve);
 print("// Public key:",Q);
 chain="{\n \"bytecode\": \"0x";
 
 px=print_setlength( 0,64);   
 py=print_setlength( _MAGIC_ENCODING,64);
 chain=chain+px+py ;
      
 for i in [1..255]:
   
   px=print_setlength( Prec[i][0], 64);
   py=print_setlength( Prec[i][1], 64);
   #print("\n -- \n px=", px, "\n py=",py );
   chain=chain+px+py ;
   
 chain=chain +"\"\n}\n";
 filep.write(chain);
 filep.close();

 return 0;


def Print_Table_sol( Q, Curve):
 C_filepath=FILE_NAME+'.sol';
 filep = open(C_filepath,'w');
 
 Prec=Precompute_Pubkey(Q, Curve);
 
 chain="// Public key\n//x:"+print_setlength(Q[0],64)+ " y:"+print_setlength(Q[1],64);
 
 filep.write(chain);
 chain="\n bytes constant x=hex\"";
 
 px=print_setlength( 0,64);   
 py=print_setlength( _MAGIC_ENCODING,64);
 chain=chain+px+py ;
      
 for i in [1..255]:
   
   px=print_setlength( Prec[i][0], 64);
   py=print_setlength( Prec[i][1], 64);
   #print("\n -- \n px=", px, "\n py=",py );
   chain=chain+px+py ;
   
 chain=chain +"\"\n";
 filep.write(chain);
 filep.close();

 return 0;
 
# bytes constant x=hex"

def Print_Table_raw( Q, Curve, filename):
 C_filepath=filename;
 filep = open(C_filepath,'a');
 
 Prec=Precompute_Pubkey(Q, Curve);
 chain="";
 for i in [0..255]:
   px=print_setlength( Prec[i][0], 64);
   py=print_setlength( Prec[i][1], 64);
   #print("\n -- \n px=", px, "\n py=",py );
   chain=chain+px+py ;
   
 filep.write(chain);
 filep.close();

 return 0;

Print_Table_json(Q,secp256r1);