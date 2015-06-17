#! /usr/bin/python
#Script to send emails to multiple recipients with multiple attachments via gmail
import os 
import smtplib
import sys
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage
from email.MIMEBase import MIMEBase
from email import Encoders

image_dir = str(sys.argv[1])
#Set up crap for the attachments
files = "/home/pi/capture/" + image_dir
filenames = [os.path.join(files, f) for f in os.listdir(files)]
#print filenames


#Set up users for email
gmail_user = ""
gmail_pwd = ""
recipients = []

#Create Module
def mail(to, subject, text, attach):
   msg = MIMEMultipart()
   msg['From'] = gmail_user
   msg['To'] = ", ".join(recipients)
   msg['Subject'] = subject

   msg.attach(MIMEText(text))

   #get all the attachments
   for file in filenames:
      part = MIMEBase('application', 'octet-stream')
      part.set_payload(open(file, 'rb').read())
      Encoders.encode_base64(part)
      part.add_header('Content-Disposition', 'attachment; filename="%s"' % file)
      msg.attach(part)

   mailServer = smtplib.SMTP("smtp.gmail.com", 587)
   mailServer.ehlo()
   mailServer.starttls()
   mailServer.ehlo()
   mailServer.login(gmail_user, gmail_pwd)
   mailServer.sendmail(gmail_user, to, msg.as_string())
   # Should be mailServer.quit(), but that crashes...
   mailServer.close()

#send it
mail(recipients,
   "Motion detected at " + image_dir,
   "see attached photos",
   filenames)
