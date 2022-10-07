class LoginSession{
   String sessionKey;

   String tenantId;

   String userId;

   LoginSession(this.sessionKey, this.tenantId, this.userId);

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

}