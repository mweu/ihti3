class LoginSession{
   String sessionKey;

   String tenantId;

   String userId;

   String displanyName;

   String payrollSession;

   LoginSession(this.sessionKey, this.tenantId, this.userId, this.displanyName, this.payrollSession);

void setSession(sessionKey){
  this.sessionKey = sessionKey;
}

String getSessionKey(){
  return this.sessionKey;
}

void setTenantId(tenant){
  this.tenantId = tenant;
}

String getTenantId(){
  return this.tenantId;
}

void setUserId(user){
  this.userId = user;
}

String getUserId(){
  return this.userId;
}

void setDisplanyName(displanyName){
  this.displanyName = displanyName;
}

String getDisplanyName(){
  return this.displanyName;
}

void setPayrollSession(sessionKey){
  this.payrollSession = sessionKey;
}

String getPayrollSession(){
  return this.payrollSession;
}


}