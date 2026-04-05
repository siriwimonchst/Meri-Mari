// lib/l10n/app_strings.dart
/// All bilingual strings for the app.
class AppStrings {
  final bool isThai;
  const AppStrings({required this.isThai});

  // ignore: avoid_annotating_with_dynamic
  static AppStrings of(dynamic context) {
    return const AppStrings(isThai: false);
  }

  // ── Auth ──────────────────────────────────────────────────────────────────
  String get login => isThai ? 'เข้าสู่ระบบ' : 'Login';
  String get signUp => isThai ? 'สมัครสมาชิก' : 'Sign up';
  String get createAccount => isThai ? 'สร้างบัญชี' : 'Create account';
  String get noAccount =>
      isThai ? 'ยังไม่มีบัญชี? ' : "Don't have an account? ";
  String get alreadyHaveAccount =>
      isThai ? 'มีบัญชีแล้ว? ' : 'Already have an account? ';
  String get signIn => isThai ? 'เข้าสู่ระบบ' : 'sign in';
  String get continueWithGoogle =>
      isThai ? 'ดำเนินการต่อด้วย Google' : 'Continue with Google';
  String get email => isThai ? 'อีเมล' : 'Email';
  String get password => isThai ? 'รหัสผ่าน' : 'Password';
  String get name => isThai ? 'ชื่อ' : 'Name';
  String get forgotPassword => isThai ? 'ลืมรหัสผ่าน?' : 'Forgot password?';
  String get accountInfo => isThai ? 'ข้อมูลบัญชี' : 'Account Info';
  String get changePassword => isThai ? 'เปลี่ยนรหัสผ่าน' : 'Change Password';
  String get currentPassword =>
      isThai ? 'รหัสผ่านปัจจุบัน' : 'Current Password';
  String get newPassword => isThai ? 'รหัสผ่านใหม่' : 'New Password';
  String get confirmNewPassword =>
      isThai ? 'ยืนยันรหัสผ่านใหม่' : 'Confirm New Password';
  String get accountCreated => isThai ? 'สร้างบัญชีเมื่อ' : 'Account Created';
  String get userId => isThai ? 'รหัสผู้ใช้ (UID)' : 'User ID (UID)';
  String get passwordMismatch =>
      isThai ? 'รหัสผ่านไม่ตรงกัน' : 'Passwords do not match';
  String get passwordChangedSuccess =>
      isThai ? 'เปลี่ยนรหัสผ่านสำเร็จ' : 'Password updated successfully';
  String get wrongCurrentPassword =>
      isThai ? 'รหัสผ่านปัจจุบันไม่ถูกต้อง' : 'Wrong current password';
  String get save => isThai ? 'บันทึก' : 'Save';

  // ── Home ──────────────────────────────────────────────────────────────────
  String get searchHint => isThai ? 'ค้นหาสินค้า...' : 'Search products...';
  String get filter => isThai ? 'กรอง' : 'Filter';
  String get noProducts => isThai ? 'ไม่พบสินค้า' : 'No products found';
  String get tryOtherSearch =>
      isThai ? 'ลองค้นหาด้วยคำอื่น' : 'Try another search';
  String get all => isThai ? 'ทั้งหมด' : 'All';
  String get categoryLabel => isThai ? 'หมวดหมู่' : 'Category';
  String get seeAll => isThai ? 'ดูทั้งหมด' : 'See All';
  String get locationLabel => isThai ? 'ที่อยู่ปัจจุบัน' : 'Location';
  String get bannerShopNow => isThai ? 'ดูสินค้า' : 'Shop Now';
  String get filterTitle => isThai ? 'กรองสินค้า' : 'Filter Products';
  String get clearFilter => isThai ? 'ล้างตัวกรอง' : 'Clear';
  String get applyFilter => isThai ? 'ใช้งาน' : 'Apply';
  String get productsLabel => isThai ? 'สินค้า' : 'Products';
  String get noLocation => isThai ? 'ยังไม่มีที่อยู่' : 'No address set';

  // ── Tags ──────────────────────────────────────────────────────────────────
  String get tagNoDefect => isThai ? 'ไม่มีตำหนิ' : 'No Defect';
  String get tagBrandNew => isThai ? 'มือ 1' : 'Brand New';
  String get tagPreOwned => isThai ? 'มือ 2' : 'Pre-owned';
  String get tagMISB => 'MISB';
  String get tagCheckCard => isThai ? 'เช็คการ์ด' : 'Check Card';
  String get tagLimited => 'Limited';
  String get tagSecret => 'Secret';
  String get tagsLabel => isThai ? 'แท็ก' : 'Tags';

  /// Returns a localised display label for a raw tag key string.
  String tagLabel(String tag) {
    switch (tag.toLowerCase()) {
      case 'no defect':
      case 'nodefect':
        return tagNoDefect;
      case 'brand new':
      case 'brandnew':
      case 'มือ 1':
        return tagBrandNew;
      case 'pre-owned':
      case 'preowned':
      case 'มือ 2':
        return tagPreOwned;
      case 'misb':
        return tagMISB;
      case 'check card':
      case 'checkcard':
        return tagCheckCard;
      case 'limited':
        return tagLimited;
      case 'secret':
        return tagSecret;
      default:
        return tag;
    }
  }

  /// Predefined tag list used in filter dialogs.
  /// Each entry has 'key' (raw value) and 'label' (localised display).
  List<Map<String, String>> get predefinedTags => [
    {'key': 'brand_new', 'label': tagBrandNew},
    {'key': 'pre_owned', 'label': tagPreOwned},
    {'key': 'no_defect', 'label': tagNoDefect},
    {'key': 'misb', 'label': tagMISB},
    {'key': 'check_card', 'label': tagCheckCard},
    {'key': 'limited', 'label': tagLimited},
    {'key': 'secret', 'label': tagSecret},
  ];

  // ── Product Detail ────────────────────────────────────────────────────────
  String get condition => isThai ? 'สภาพสินค้า' : 'Condition';
  String get collection => isThai ? 'คอลเลกชัน' : 'Collection';
  String get addToCart => isThai ? 'เพิ่มในตะกร้า' : 'Add to Cart';
  String get buyNow => isThai ? 'ซื้อเลย' : 'Buy Now';
  String get addedToCart => isThai ? 'เพิ่มในตะกร้าแล้ว!' : 'Added to cart!';
  String get shippingFee => isThai ? 'ค่าจัดส่ง' : 'Shipping fee';
  String get alreadyInCart =>
      isThai ? 'สินค้านี้อยู่ในตะกร้าแล้ว' : 'Already in cart';
  String get shipping => isThai ? 'ค่าส่ง' : 'Shipping';
  String get details => isThai ? 'รายละเอียด' : 'Details';
  String get productDesc => isThai ? 'รายละเอียดสินค้า' : 'Product description';

  // ── Cart ──────────────────────────────────────────────────────────────────
  String get cart => isThai ? 'ตะกร้าของฉัน' : 'My Cart';
  String get emptyCart => isThai ? 'ตะกร้าว่างอยู่' : 'Your cart is empty';
  String get checkout => isThai ? 'ชำระเงิน' : 'Checkout';
  String get selectAll => isThai ? 'เลือกทั้งหมด' : 'Select all';
  String get orderSummary => isThai ? 'สรุปคำสั่งซื้อ' : 'Order Summary';
  String get subtotal => isThai ? 'ราคารวม' : 'Subtotal';
  String get shippingCost => isThai ? 'ค่าขนส่ง' : 'Shipping';
  String get totalPayment => isThai ? 'ยอดชำระ' : 'Total';

  // ── Checkout ──────────────────────────────────────────────────────────────
  String get checkoutTitle => isThai ? 'ชำระเงิน' : 'Checkout';
  String get deliveryAddress => isThai ? 'ที่อยู่จัดส่ง' : 'Delivery address';
  String get noAddressSelected =>
      isThai ? 'ยังไม่ได้เลือกที่อยู่' : 'No address selected';
  String get paymentMethod => isThai ? 'วิธีชำระเงิน' : 'Payment method';
  String get qrPayment => isThai ? 'QR Code / พร้อมเพย์' : 'QR / PromPay';
  String get qrPromptPay => isThai ? 'สแกน QR พร้อมเพย์' : 'QR / PromptPay';
  String get cashOnDelivery => isThai ? 'เก็บเงินปลายทาง' : 'Cash on Delivery';
  String get placeOrder => isThai ? 'สั่งซื้อ' : 'Place Order';
  String get orderPlaced => isThai ? 'สั่งซื้อสำเร็จ!' : 'Order placed!';
  String get orderPlacedMsg => isThai
      ? 'รายการสั่งซื้อของคุณถูกบันทึกแล้ว'
      : 'Your order has been saved';
  String get backToHome => isThai ? 'กลับหน้าหลัก' : 'Back to Home';
  String get uploadSlip =>
      isThai ? 'อัพโหลดสลิปการโอน' : 'Upload transfer slip';
  String get slipUploaded => isThai ? 'อัพโหลดสลิปสำเร็จ!' : 'Slip uploaded!';
  String get verifyingSlip =>
      isThai ? 'รอตรวจสอบสลิปชำระเงิน' : 'Verifying payment slip...';

  // ── QR Payment ────────────────────────────────────────────────────────────
  String get scanQrToPay => isThai ? 'สแกน QR เพื่อชำระเงิน' : 'Scan QR to pay';
  String get payLater => isThai ? 'ชำระภายหลัง' : 'Pay Later';
  String get waitingVerification =>
      isThai ? 'รอตรวจสอบสลิปชำระเงิน' : 'Waiting for payment verification...';
  String get amountDue => isThai ? 'ยอดที่ต้องชำระ' : 'Amount Due';
  String get scanToTransfer =>
      isThai ? 'สแกน QR เพื่อโอนเข้าบัญชี' : 'Scan QR to transfer';
  String get verifyingPaymentMsg => isThai
      ? 'ระบบกำลังตรวจสอบการชำระเงินของคุณ'
      : 'Your payment is being verified';
  String get confirmLabel => isThai ? 'ยืนยัน' : 'Confirm';

  // ── Orders ────────────────────────────────────────────────────────────────
  String get orders => isThai ? 'การซื้อของฉัน' : 'My Purchases';
  String get orderDetail => isThai ? 'รายละเอียดคำสั่งซื้อ' : 'Order Details';
  String get shippingAddress =>
      isThai ? 'ที่อยู่ในการจัดส่ง' : 'Shipping Address';
  String get copy => isThai ? 'คัดลอก' : 'Copy';
  String get orderId => isThai ? 'หมายเลขคำสั่งซื้อ' : 'Order ID';
  String get afterSales => isThai ? 'บริการหลังการขาย' : 'After-sales Service';
  String get contactSeller => isThai ? 'ติดต่อผู้ขาย' : 'Contact Seller';
  String get helpCenter => isThai ? 'ศูนย์ช่วยเหลือ' : 'Help Center';
  String get noOrders => isThai ? 'ยังไม่มีรายการสั่งซื้อ' : 'No orders yet';
  String get orderStatus => isThai ? 'สถานะ' : 'Status';
  String get statusPending => isThai ? 'รอดำเนินการ' : 'Pending';
  String get statusConfirmed => isThai ? 'ยืนยันแล้ว' : 'Confirmed';
  String get statusShipped => isThai ? 'จัดส่งแล้ว' : 'Shipped';
  String get statusDelivered => isThai ? 'ถึงมือแล้ว' : 'Delivered';
  String get statusCancelled => isThai ? 'ยกเลิกแล้ว' : 'Cancelled';
  String get orderItems => isThai ? 'รายการสินค้า' : 'Items';
  String get orderTotal => isThai ? 'ยอดรวม' : 'Total';
  String get uploadPaymentSlip =>
      isThai ? 'อัพโหลดหลักฐานการโอน' : 'Upload payment slip';
  String get slipUploadedSuccess =>
      isThai ? 'อัพโหลดสลิปสำเร็จ!' : 'Slip uploaded!';
  String get orderDate => isThai ? 'วันที่สั่ง' : 'Order Date';
  String get tabAll => isThai ? 'ทั้งหมด' : 'All';
  String get tabToPay => isThai ? 'ที่ต้องชำระ' : 'To Pay';
  String get tabToShip => isThai ? 'ที่ต้องจัดส่ง' : 'To Ship';
  String get tabToReceive => isThai ? 'ที่ต้องได้รับ' : 'To Receive';
  String get tabToRate => isThai ? 'สำเร็จ' : 'Success';
  String get emptyOrders => isThai ? 'ยังไม่มีออเดอร์' : 'No orders yet';
  String get payWithin => isThai ? 'ชำระเงินภายใน' : 'Pay within';
  String get sellerVerificationMsg => isThai
      ? 'ผู้ขายจะตรวจสอบสลิปภายใน 24 ชม.'
      : 'Seller will verify the slip within 24 hours.';
  String get payViaPromptPay =>
      isThai ? 'ชำระผ่านช่องทาง QR พร้อมเพย์' : 'Pay via QR PromptPay';
  String get viewPurchaseHistory =>
      isThai ? 'ดูประวัติการซื้อ' : 'View purchase history';
  String get rateLabel => isThai ? 'ให้คะแนน' : 'To Rate';
  String get mallLabel => 'Official';
  String get shopOfficialStore => 'Meri-Mari Official Store';
  String get orderTotalLabel => isThai ? 'ยอดสั่งซื้อรวม' : 'Order Total';
  String get copiedLabel => isThai ? 'คัดลอกแล้ว' : 'Copied';
  String get orderTimeLabel => isThai ? 'เวลาที่สั่งซื้อ' : 'Order Time';
  String get cancelOrderLabel => isThai ? 'ยกเลิกออเดอร์' : 'Cancel Order';
  String get payNowLabel => isThai ? 'ชำระเงิน' : 'Pay Now';
  String get recommendedShop => 'Official';
  String get confirmCancelLabel =>
      isThai ? 'ยืนยันการยกเลิก' : 'Confirm Cancel';

  // ── Favorites ─────────────────────────────────────────────────────────────
  String get favorites => isThai ? 'ถูกใจ' : 'Favorites';
  String get myFavorites => isThai ? 'สินค้าที่ถูกใจ' : 'My Favorites';
  String get noFavorites =>
      isThai ? 'ยังไม่มีสินค้าที่ถูกใจ' : 'No favorites yet';

  // ── Account Settings ──────────────────────────────────────────────────────
  String get accountSettings => isThai ? 'ตั้งค่าบัญชี' : 'Account Settings';
  String get displayName => isThai ? 'ชื่อที่แสดง' : 'Display Name';
  String get changePhoto => isThai ? 'เปลี่ยนรูปโปรไฟล์' : 'Change Photo';
  String get deletePhoto => isThai ? 'ลบรูปโปรไฟล์' : 'Remove Photo';
  String get saveChanges => isThai ? 'บันทึกการเปลี่ยนแปลง' : 'Save changes';
  String get editProfile => isThai ? 'แก้ไขโปรไฟล์' : 'Edit Profile';
  String get changesSaved => isThai ? 'บันทึกแล้ว!' : 'Saved!';

  // ── Notifications ─────────────────────────────────────────────────────────
  String get notificationsTitle => isThai ? 'การแจ้งเตือน' : 'Notifications';

  // ── Profile ───────────────────────────────────────────────────────────────
  String get profile => isThai ? 'โปรไฟล์' : 'Profile';
  String get myAddress => isThai ? 'ที่อยู่ของฉัน' : 'My Address';
  String get account => isThai ? 'บัญชี' : 'Account';
  String get notifications => isThai ? 'การแจ้งเตือน' : 'Notifications';
  String get noNotifications =>
      isThai ? 'ยังไม่มีการแจ้งเตือน' : 'No notifications yet';
  String get noAddress => isThai ? 'ยังไม่มีที่อยู่' : 'No addresses yet';
  String get devices => isThai ? 'อุปกรณ์' : 'Devices';
  String get passwords => isThai ? 'รหัสผ่าน' : 'Passwords';
  String get settings => isThai ? 'การตั้งค่า' : 'Settings';
  String get language => isThai ? 'ภาษา' : 'Language';
  String get languageValue => isThai ? 'ภาษาไทย' : 'English UK';
  String get logout => isThai ? 'ออกจากระบบ' : 'Logout';
  String get emailStatus => isThai ? 'สถานะอีเมล' : 'Email Status';
  String get verified => isThai ? 'ยืนยันแล้ว ✓' : 'Verified ✓';
  String get notVerified => isThai ? 'ยังไม่ยืนยัน' : 'Not verified';
  String get logoutConfirmTitle => isThai ? 'ออกจากระบบ?' : 'Log out?';
  String get logoutConfirmMsg => isThai
      ? 'คุณต้องการจะออกจากระบบจากบัญชีของคุณใช่หรือไม่?'
      : 'Are you sure you want to log out from your account?';
  // Address
  String get myAddressTitle => isThai ? 'ที่อยู่จัดส่ง' : 'Delivery Address';
  String get addAddress => isThai ? '+ เพิ่มที่อยู่' : '+ Add address';
  String get deleteAddressTitle => isThai ? 'ลบที่อยู่' : 'Delete address';
  String get deleteAddressConfirm =>
      isThai ? 'ต้องการลบที่อยู่นี้ใช่หรือไม่?' : 'Remove this address?';
  String get cancelLabel => isThai ? 'ยกเลิก' : 'Cancel';
  String get deleteLabel => isThai ? 'ลบ' : 'Delete';
  String get editLabel => isThai ? 'แก้ไข' : 'Edit';
  String get setAsDefault => isThai ? 'ตั้งเป็นหลัก' : 'Set as default';
  String get currentAddress => isThai ? 'ที่อยู่ปัจจุบัน' : 'Default';
  String get addNewAddress => isThai ? 'เพิ่มที่อยู่ใหม่' : 'Add new address';
  String get editAddress => isThai ? 'แก้ไขที่อยู่' : 'Edit address';
  String get saveAddress => isThai ? 'บันทึก' : 'Save';
  String get setAsDefaultLabel =>
      isThai ? 'ตั้งเป็นที่อยู่ปัจจุบัน' : 'Set as default address';
  // Home extras
  String get emptyCartHint =>
      isThai ? 'เพิ่มสินค้าจากหน้าหลัก' : 'Add items from Home';
  String get favHint =>
      isThai ? 'กดหัวใจบนสินค้าที่ชอบ' : 'Tap ♥ on a product you like';
  String get clearAll => isThai ? 'ล้างทั้งหมด' : 'Clear all';
  String get accountAndSettings =>
      isThai ? 'บัญชีและการตั้งค่า' : 'Account & Settings';
  String get selectLanguage =>
      isThai ? 'เลือกภาษา / Select Language' : 'Select Language';
  String get addressLine1 => isThai ? 'ที่อยู่บรรทัดที่ 1' : 'Address line 1';
  String get addressLine2 =>
      isThai ? 'ที่อยู่บรรทัดที่ 2 (ไม่บังคับ)' : 'Address line 2 (optional)';
  String get cityLabel => isThai ? 'จังหวัด/เมือง' : 'City';
  String get zipCodeLabel => isThai ? 'รหัสไปรษณีย์' : 'ZIP / Postcode';
  String get countryLabel => isThai ? 'ประเทศ' : 'Country';
  String get fieldRequired => isThai ? 'จำเป็นต้องระบุ' : 'is required';
  String get settingsAndSecurity =>
      isThai ? 'ตั้งค่าและความปลอดภัย' : 'Settings & Security';
  String get myInfo => isThai ? 'ข้อมูลของฉัน' : 'My Info';
  String get support => isThai ? 'ศูนย์ความช่วยเหลือ' : 'Support';
  String get helpCentre => isThai ? 'ศูนย์ช่วยเหลือ' : 'Help Centre';
  String get communityRules => isThai ? 'กฎของชุมชน' : 'Community Rules';
  String get policies => isThai ? 'นโยบายของ Meri-Mari' : 'Meri-Mari Policies';
  String get contactUs => isThai ? 'ติดต่อเรา' : 'Contact Us';
  String get about => isThai ? 'เกี่ยวกับเรา' : 'About';
  String get requestAccountDeletion =>
      isThai ? 'ลบบัญชีผู้ใช้' : 'Request Account Deletion';
  String get deleteAccountConfirmMsg => isThai
      ? 'เราเสียใจที่คุณจะไม่ได้ใช้งานบริการของเราอีก แต่หากคุณได้ทำการลบบัญชีผู้ใช้แล้วไม่สามารถทำการกู้กลับมาได้'
      : 'We\'re sorry to see you go. Once deleted, your account cannot be recovered.';
  String get okLabel => isThai ? 'ตกลง' : 'OK';
  String get edit => isThai ? 'แก้ไข' : 'Edit';
  String get done => isThai ? 'เสร็จสิ้น' : 'Done';
  String get unfavoriteSelected => isThai ? 'เลิกถูกใจ' : 'Remove';
  String get selectedCount => isThai ? 'เลือกแล้ว' : 'Selected';

  // ── Nav ───────────────────────────────────────────────────────────────────
  String get home => isThai ? 'หน้าหลัก' : 'Home';
  String get explore => isThai ? 'ค้นหา' : 'Explore';
  String get navProfile => isThai ? 'โปรไฟล์' : 'Profile';
  String get navOrders => isThai ? 'ออเดอร์' : 'Orders';
}
