import smtplib

# email:postgresqlp@yahoo.com
# password: kshitijgupta

def send_email_internal(_from,_password,smtp,port,receiver,subject,send_message):
  sender = _from
  receivers = receiver
  message = ("From: %s\nTo: %s\nSubject: %s\n\n %s"
   % (_from,receiver,subject,send_message))
  try:
    smtpObj = smtplib.SMTP(smtp,port)
    smtpObj.ehlo()
    smtpObj.starttls()
    smtpObj.login(_from, _password)
    smtpObj.sendmail(sender, receivers,message)
    print ('Successfully sent email')
  except smtplib.SMTPException:
    print ('Error: unable to send email')
  return message

def send_mail(receiver,subject,send_message):
  send_email_internal('postgresqlp@yahoo.com','hvyhppwuryklbcgr','smtp.mail.yahoo.com',587,receiver,
              subject,send_message)

# send_mail('anshprakash1997@gmail.com','Sending E-Mail From PostgreSQL','Hi,\n How do you do ..')

