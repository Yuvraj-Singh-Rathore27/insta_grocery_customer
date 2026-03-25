class ApiUrl {
  //live
  static const apiUrl = "http://43.205.42.216:8001/";
  static const DOMAIN_URL = "http://43.205.42.216/";
  //sate

  //type of provider
  static const String providerTypeDoctor = "doctor";
  static const String providerTypeHospital = "hospital";
  static const String providerTypeClinic = "Clinic";
  static const String providerTypeLab = "laboratory";
  static const String providerTypeScanCenter = "scan_center";
  static const String providerTypePharmacy = "pharmacy";
  static const String providerTypeDeliveryBoy = "Delivery";
  static const String providerAambulance = "ambulance";

  bool isPlayStore = false;
  bool isbb = false;
  bool is_debug_mode = true;

  static const String DEVICE_TYPE_ANDROID = "A";

  static const String DATA = "DATA";
  static const String DATA1 = "DATA1";
  static const String DATA2 = "DATA2";
  static const String DATA3 = "DATA3";
  static const String UserType = "user";

  static const apiMethodGet = 'GET';
  static const apiMethodPost = "POST";
  static const String fileUploadUrl = "prod/pharmacy/document";
  static const String fileUploadScanCenterUrl = "prod/scanCenter/document";
  static const String fileUploadLabTestUrl = "prod/labtest/document";
  static const String fileUploadResume = "prod/Job/document";

  static const String EVENT_CALL = "CALL";
  static const String EVENT_ORDER = "ORDER";
  static const String EVENT_DIRECTION = "DIRECTION";
  static const String EVENT_PRODUCT_INFO = "PRODUCT_INFO";
  static const String EVENT_DETAILS_VIEW = "Detail_view";
  static const String EVENT_ENQUIREY = "Enquiries";

  static const cityListApi = "${apiUrl}admin/city/";
  static const stateListApi = "${apiUrl}admin/state/";
  static const uploadFileUrl = "${apiUrl}common/upload-file/?s3_path=";
  static const apiUrlUserSignup = "${apiUrl}users/sign-up/";
  static const apiUrlLoginGetOtp = "${apiUrl}security/get-otp/";
  static const apiLoginOtpVarification = "${apiUrl}users/login/otp/";
  static const apiLoginWithPssword = "${apiUrl}users/login/password/";
  static const sendOtpEmailApi =
      "${apiUrl}common/send-email/reset-password?to_email=";
  static const API_URL_FORGET_PASSWORD = "${apiUrl}forgot-password";
  static const API_URL_RESET_PASSWORD_OTP = "${apiUrl}reset-password";
  static const API_URL_CHANG_PASSWORD = "${apiUrl}change-password";
  static const doctorListSearchAPi = "${apiUrl}doctors";
  static const doctorTimeSlot = "${apiUrl}doctors/doctor_slots/?doctor_id=";
  static const createBookingApi = "${apiUrl}booking/";
  static const getUserDetailsApi = "${apiUrl}users/";
  static const bannerListApi = "${apiUrl}admin/banner/?";
  static const bookingStatusList = "${apiUrl}doctors/list-appointment-status/";
  static const userAciveDeactive = "${apiUrl}users/activate-deactivate-user/";

  //family Member
  static const getFamillyMemberListApi = "${apiUrl}family-member/";
  static const addFamilyMemberApi = "${apiUrl}family-member/";
  static const getRelationShipApi = "${apiUrl}family-member/relationships/";
  static const deleteFamilyMember = "${apiUrl}family-member/";

  //hospital list
  static const getHospitalList = "${apiUrl}hospital/";
  static const getClinicList = "${apiUrl}hospital/?hospital_type=Clinic";

  //pharmacy apis
  static const getPharmacyList = "${apiUrl}stores/";

  //get Pharmacy List
  static const getHomePharmacyList =
      "${apiUrl}stores/?vendor_type_id=1&display_only_active=true&page=1&size=50";

  static const pharmacyOrderCreateUrl = "${apiUrl}orders/new-order/";
  static const pharmacyOrderList = "${apiUrl}medicine-order/";
  static const pharmacyOrderListUrl = "${apiUrl}medicine-order/?";
  static const pharmacyUpdateOrderStatusUrl = "${apiUrl}medicine-order/";
  static const getPharmacyCategoryList =
      "${apiUrl}pharmacy/list-product-types/";
  static const getPharmacySubCategoryCategoryList =
      "${apiUrl}pharmacy/list-product-category/?page=1&size=50&product_type_id=";
  static const getProductList =
      "${apiUrl}pharmacy/list-products/?page=1&size=50";
  static const getMeidcanProductList = "${apiUrl}medicines/list-medicines/";
  static const getMeidcanSubcategoty =
      "${apiUrl}pharmacy/list-pharmacy-product-subtypes/?page=1&size=50";
  static const API_STORE_TYPE_TAG_SERVCIES =
      "${apiUrl}stores/tags/list-store-tags/?display_type=active&order_by=created_at&descending=true&page=1&size=50";
  //scan center list
  static const getScanCenterList = "${apiUrl}scan-center/?page=1&size=50";
  static const scanCenterOrderCreateUrl = "${apiUrl}scan-center/booking/";
  static const scanTestChooseListUrl = "${apiUrl}scan-center/scans/";

  //lab test
  static const getLabTestListing = "${apiUrl}laboratory/?page=1&size=50";
  static const bookLabTestApi = "${apiUrl}laboratory/booking/";
  static const getLabTestList = "${apiUrl}laboratory/lab-tests/";
  static const getLabTestListUser =
      "${apiUrl}laboratory/display-lab-tests-user/";
  static const getLabTestPackageList = "${apiUrl}laboratory/tests-packages/";
  static const getLabCategoryList = "${apiUrl}laboratory/list-category/";
  static const getLabSubcategoryList =
      "${apiUrl}laboratory/list-lab-sub-category/?category_id=";
  static const updateLabOrderStatus = "${apiUrl}laboratory/booking/";

  //ambulance
  static const driverAmbulanceTypeList = "${apiUrl}ambulance/types/";
  static const driverNearMeAmbulance =
      "${apiUrl}ambulance/booking/find-near-by-ambulances";
  static const bookCabApi = "${apiUrl}ambulance/booking/";
  static const bookingListApi = "${apiUrl}ambulance/booking/?page=1&size=50";

  static const placeDetailsApi =
      "https://maps.googleapis.com/maps/api/place/details/json?place_id";
  static const mapApiKey = "AIzaSyAhch18P_emZhw7RkyewrmLNk8Snhs0w4U";

  static const feedbackUrl = "${apiUrl}feedback/";

  //send message
  static const sendMessage = "${apiUrl}conversation/";

  //vital
  static const getVitalReportUrl = "${apiUrl}vitals/";
  static const addVitalReportUrl = "${apiUrl}vitals/";
  static const updateVitalReportUrl = "${apiUrl}vitals/update-vitals/";
  static const updateLabReportUrl = "${apiUrl}vitals/update-lab-reports/";

  //jobs
  static const postResumeUrl = "${apiUrl}admin/jobs/job-seeker/post-resume/";
  static const updateResumeUrl =
      "${apiUrl}admin/jobs/job-seeker/update-profile/";
  static const getJobTypeUrl = "${apiUrl}admin/jobs/job-types/";
  static const getJobListUrl =
      "${apiUrl}admin/jobs/job-provider/list-jobs/?page=1&size=50";
  static const getResumeDetails =
      "${apiUrl}admin/jobs/job-seeker/list-candidate/?/?user_type=user&candidate_id=";
  static const getResumeListCandedate="${apiUrl}admin/jobs/job-seeker/list-candidate";
  static const applyJobUrl = "${apiUrl}admin/jobs/job-seeker/apply_job/";
  static const postJobByProviderUrl =
      "${apiUrl}admin/jobs/job-provider/post-job/";
  static const getJobCategoryUrl =
      "${apiUrl}admin/jobs/category-list/";
  static const getJobSubCategoryUrl =
      "${apiUrl}admin/jobs/sub-category-list/?category_id=";

  static const getListAppliedJob =
      "${apiUrl}admin/jobs/job-seeker/list-applied_jobs/";

  static const getListJobTags =
      "${apiUrl}admin/jobs/job-tag-list/?display_type=all&order_by=created_at&descending=true&page=1&size=50";

    

  //user add management
  static const addUserAddressUrl = "${apiUrl}user/manage-address/add-address";
  static const updateUserAddressUrl =
      "${apiUrl}user/manage-address/update-address/";
  static const userAddressListingUrl =
      "${apiUrl}user/manage-address/list-addresses/";

  //add favorites
  static const addFavoritesUrl = "${apiUrl}user/favorites/add-favorites";
  static const ListFavoritesUrl = "${apiUrl}user/favorites/list-favorites/";
  static const DeleteFavoritesItemUrl =
      "${apiUrl}user/favorites/remove-from-favorites/";

  static const API_STORE_TYPE_CATEGORY = "${apiUrl}admin/store_type/";
  static const API_BUSINESS_TYPE_CATEGORY =
      "${apiUrl}admin/store_group/list-store-groups/?order_by=created_at&descending=true&display_type=active";
  //main catgory accouding to store type

  static const API_MAIN_CATEGORY =
      "${apiUrl}stores/list-product-category/?order_by=created_at&store_type_id=";
  static const API_SUB_CATEGORY =
      "${apiUrl}stores/list-product-sub-category/?order_by=created_at&product_category_id=";
  static const API_CHILD_SUB_CATEGORY =
      "${apiUrl}stores/list-product-child-sub-category/?order_by=created_at&product_sub_category_id=";

  // static const API_PRODUCT_LIST = "${apiUrl}stores/list-products/?category_id=";
  static const API_PRODUCT_LIST = "${apiUrl}stores/list-products/?";
  static const API_STORE_DETAILS = "${apiUrl}stores/";

  //events_create
  static const API_AUDIT_LOG_CREATE = "${apiUrl}audit-log/audit-logs/";

  //services
  static const API_SERVICES_LIST =
      "${apiUrl}grocery-service/list-grocery-services/";
  static const API_SERVICES_LIST_BY_STORE = "${apiUrl}stores/";
  static const API_INTRESTED_SERVCIES = "${apiUrl}interested-service/";
  static const GET_API_INTRESTED_SERVCIES = "${apiUrl}interested-service/";

  //market Place
  static const API_MP_SUPERCATEGORY_LIST="${apiUrl}admin/market-place-super-category/?display_type=active";

  static const API_MP_CATEGORY_LIST =
      "${apiUrl}admin/market-place/list-categories/";
  static const API_MP_SUB_CATEGORY_LIST =
      "${apiUrl}admin/market-place/list-sub-categories/?category_id=";
  static const Add_Product_Market_place = "${apiUrl}market-place/add-product/";
  static const Get_Product_Market_Place =
      "${apiUrl}market-place/list-products/?";
  static const Put_Product_Market_PLACE =
      "${apiUrl}market-place/update-product/";
  static const API_MP_BRAND_LIST =
      "${apiUrl}admin/market-place/list-brands/?order_by=created_at&descending=true&page=1&size=50";
  static const GET_PRODUCT_BY_ID =
      "${apiUrl}market-place/list-product/products_id/";
  static const PETCH_PRODUCT_BY_ID =
      "${apiUrl}market-place/activate-deactivate-product";


  // market place interset
  static const POST_MARKET_PLACE_INTERESTED =
      "${apiUrl}market-place/add-interest/";
  static const GET_MARKET_PLACE_INTERESTED =
      "${apiUrl}market-place/user-interests/";
  static const POST_MARKET_PLACE_PRODUCT_MESSAGE="${apiUrl}market-place/chat/send-message/";
  static const API_DOCTORS_LIST = "${apiUrl}stores/doctor/list-members/";

  // store job module 
    static const getJobByStoreApi="${apiUrl}stores/jobs/";
    static const applyJobStoreUrl = "${apiUrl}stores/jobs/job-seeker/apply_job";


    // store Video 
    static const getStoreVideo="${apiUrl}stores/videos/";
    static const getVideoCategoury="${apiUrl}stores/videos/video-category/?display_type=all&order_by=created_at&descending=true&page=1&size=50";
    static const postStoreVideoReaction="${apiUrl}stores/videos/reactions/react";
    static const getStoreVideoTotalReaction="${apiUrl}stores/videos/reactions/";



    
    // store offer video
    static const getStoreOffer="${apiUrl}store/offer/store_offer/";
    static const getStoreOfferCategory="${apiUrl}store/offer/admin-offer-category";
    static const getStoreOfferSubCategory="${apiUrl}store/offer/admin-offer-subcategory/";

    // customer event managment

    static const getCustomerEventCategory="${apiUrl}admin/event_categories/?display_type=all";
        static const getCustomerEventSubCategory="${apiUrl}admin/event_subCategories/?display_type=all";

    static const getCustomerEvent =
    "${apiUrl}customer/event/get-event/";
    static const postCustomerEvent="${apiUrl}customer/event/add-event";
    static const registerCustomerEvent="${apiUrl}customer/event_register/register";
static const getRegisterCustomerEvent =
    "${apiUrl}customer/event_register/event-user";



    // internship program 

    static const getstoreinternshipProgramCategory="${apiUrl}internship-program-categories/?display_type=active&order_by=id";
    static const getstoreinternshipProgramsubcategory="${apiUrl}internship-program-subcategories/";
    static const getstoreinternshiProgram="${apiUrl}internships-program/";


    static const getapplyinternship="${apiUrl}internship-applications/apply/";


     // skill program api 
    static const getskillprogramtype="${apiUrl}admin/skill-program-types/?display_type=active";
    static const getskillprogramcategory="${apiUrl}admin/skill-program-category/?display_type=active";
    static const getskillprogramsubcategory="${apiUrl}admin/skill-program-sub-category/";
    static const getskillprogram="${apiUrl}admin/skill-program/";
    static const appliedskillprogram="${apiUrl}skill-applications/apply/";








}
