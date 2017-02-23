/**
 * Example of an ios10 rich media push notification using
 * the salesforce universal notification framework
 */
public with sharing class PushPriceChangeNotification {
    
     @InvocableMethod(label='Push Price Change Notification')
    public static void pushNotification(List<Id> propertyId) {
        Id propId = propertyId[0]; // If bulk, only post first to avoid spamming
        System.debug('Price updated on property id '+propId);
        Property__c property = [SELECT Name, Picture__c, Price__c from Property__c WHERE Id=:propId];
        String message = property.Name + '. New Price: $' + property.Price__c.setScale(0).format();
        
        Set<String> userIds = new Set<String>();

        List<Favorite__c> favorites = [SELECT user__c, user__r.Name from favorite__c WHERE property__c=:propId AND User__c != null];
        for (Favorite__c favorite : favorites) {
            userIds.add(favorite.user__c);
             System.debug('Sending price change notifications to '+favorite.user__r.Name);
        }

      //universal notification service
         Messaging.PushNotification msg = new Messaging.PushNotification();
       
        //manually create an ios10 rich-media APS payload
        Map<String, Object> alertPayload = new Map<String, Object>();
        alertPayload.put('title', 'Price Changed to $'+property.Price__c.setScale(0).format());
        alertPayload.put('subtitle', property.Name);
        alertPayload.put('body', 'Heads up! The list price on a property you favorited has just been reduced.');
        
        Map<String, Object> apsPayload = new Map<String, Object>();
        apsPayload.put('mutable-content', 1);   //we need this for the ios mutablecontent extension to fire.
        apsPayload.put('media-attachment', property.Picture__c);
        apsPayload.put('alert',alertPayload);
        
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('aps', apsPayload);
        payload.put('media-attachment', property.Picture__c);
        payload.put('property-id', property.id);
        
        
         Map<String, String> userData = new Map<String, String>{
          'propertyid' => property.Id
         };
              
        //Map<String, Object> payload = Messaging.PushNotificationPayload.apple(message, '', 1, userData);
        msg.setPayload(payload);
        msg.send('DreamhouseNativeMobile', userIds);
            
        
       
    }
}
