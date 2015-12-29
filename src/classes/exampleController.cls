public class exampleController { 

        String uname;
        Integer count = 0;
        
        public PageReference incrementCounter() {
                count++;
                return null;
        }
        public Integer getCount() {
                return count;
        }

        public String getUsername() {
                return uname;
        }

        public PageReference sayHello() {
                uname = UserInfo.getName();
                return null;
        }

        public void setState(String n) {
                state = n;
        }

        public String getState() {
                return state;
        }

        public PageReference methodOne() {
                return null;
        }

        private String state = 'no';

        public static testMethod void testCompleteAll(){
                PageReference cur = System.CurrentPageReference();
                String url = cur.getUrl();

                exampleController controller = new exampleController(); 
        controller.incrementCounter();
        controller.sayHello();
                String sta = controller.getState();
                String un = controller.getUsername();
        controller.setState(sta + 'e');
                Integer iun = controller.getCount();
        controller.methodOne();
        }

}