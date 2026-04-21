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
  String get registrationSuccess => isThai
      ? 'สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ'
      : 'Registration successful! Please login.';
  String get save => isThai ? 'บันทึก' : 'Save';

  String get forgotPasswordTitle => isThai ? 'ลืมรหัสผ่าน' : 'Forgot Password';
  String get forgotPasswordDemoMsg => isThai
      ? 'เนื่องจากแอปพลิเคชันเวอร์ชันนี้เป็นเวอร์ชันทดลองใช้งาน (Demo) ฟีเจอร์นี้กำลังอยู่ระหว่างการพัฒนา ขออภัยในความไม่สะดวก'
      : 'As this is a Demo version, the password recovery feature is currently under development. We apologize for any inconvenience.';
  String get enterEmailHint => isThai
      ? 'กรุณากรอกอีเมลที่ลงทะเบียนไว้'
      : 'Please enter your registered email';
  String get sendResetLink => isThai ? 'ส่งลิงก์กู้คืน' : 'Send Reset Link';
  String get resetLinkSent => isThai
      ? 'ส่งลิงก์กู้คืนรหัสผ่านไปยังอีเมลของคุณเรียบร้อยแล้ว'
      : 'Password reset link sent to your email.';
  String get emailNotFound =>
      isThai ? 'ไม่พบอีเมลนี้ในระบบ' : 'Email not found.';
  String get invalidEmail =>
      isThai ? 'รูปแบบอีเมลไม่ถูกต้อง' : 'Invalid email format.';
  String get loginSuccess => isThai ? 'เข้าสู่ระบบสำเร็จ' : 'Login successful';
  String get welcomeBack => isThai ? 'ยินดีต้อนรับกลับ!' : 'Welcome Back!';
  String get authReadyToShop => isThai
      ? 'พร้อมค้นหาสินค้าที่คุณชอบแล้วหรือยัง?\nการช้อปปิ้งของคุณเริ่มต้นที่นี่'
      : 'Ready to find your favorite items?\nYour shopping journey starts here.';
  String get enterEmail => isThai ? 'กรอกอีเมล' : 'Enter email';
  String get rememberMe => isThai ? 'จดจำฉัน' : 'Remember me';
  String get wrongPassword => isThai ? 'รหัสผ่านไม่ถูกต้อง' : 'Wrong password';


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
  String get noLocation => isThai ? 'ที่อยู่ปัจจุบัน' : 'Location';
  String get recommendedKeywords =>
      isThai ? 'คำค้นหาแนะนำ' : 'Recommended Labels';
  String get searchRecommendationTitle =>
      isThai ? 'หรือคุณต้องการค้นหาสิ่งนี้' : 'Or you might like this';
  String get backLabel => isThai ? 'ย้อนกลับ' : 'Back';

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

  /// Normalizes a raw tag string into one of the standard filter keys.
  String normalizeTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'brand new':
      case 'brandnew':
      case 'มือ 1':
      case 'brand_new':
        return 'brand_new';
      case 'pre-owned':
      case 'preowned':
      case 'มือ 2':
      case 'pre_owned':
        return 'pre_owned';
      case 'no defect':
      case 'nodefect':
      case 'ไม่มีตำหนิ':
      case 'no_defect':
        return 'no_defect';
      case 'misb':
        return 'misb';
      case 'check card':
      case 'checkcard':
      case 'เช็คการ์ด':
      case 'check_card':
        return 'check_card';
      case 'limited':
        return 'limited';
      case 'secret':
        return 'secret';
      default:
        return tag.toLowerCase().replaceAll(' ', '_');
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
  String get productDesc => isThai
      ? 'รับประกันของแท้ 100% จัดส่งผ่านระบบคุ้มครองการซื้อขาย เงินของคุณจะถูกโอนไปยังผู้ขายหลังจากที่คุณยืนยันการรับสินค้าแล้วเท่านั้น'
      : '100% authentic. Shipped via Escrow your payment is released to the seller only after you confirm receipt.';

  // ── Cart ──────────────────────────────────────────────────────────────────
  String get cart => isThai ? 'ตะกร้าของฉัน' : 'My Cart';
  String get emptyCart => isThai ? 'ตะกร้าว่างอยู่' : 'Your cart is empty';
  String get checkout => isThai ? 'ชำระเงิน' : 'Checkout';
  String get selectAll => isThai ? 'เลือกทั้งหมด' : 'Select all';
  String get orderSummary => isThai ? 'สรุปคำสั่งซื้อ' : 'Order Summary';
  String get subtotal => isThai ? 'ราคารวม' : 'Subtotal';
  String get shippingCost => isThai ? 'ค่าขนส่ง' : 'Shipping';
  String get totalPayment => isThai ? 'ยอดชำระ' : 'Total';
  String get totalLabel => isThai ? 'รวมการสั่งซื้อ' : 'Total';


  // ── Checkout ──────────────────────────────────────────────────────────────
  String get checkoutTitle => isThai ? 'ชำระเงิน' : 'Checkout';
  String get checkoutSubtotal => isThai ? 'ยอดรวมสินค้า' : 'Subtotal';

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
      isThai ? 'อัปโหลดสลิปการโอน' : 'Upload transfer slip';
  String get slipUploaded => isThai ? 'อัปโหลดสลิปสำเร็จ!' : 'Slip uploaded!';
  String get verifyingSlip =>
      isThai ? 'รอตรวจสอบสลิปการชำระเงิน' : 'Verifying payment slip...';

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
      isThai ? 'อัปโหลดหลักฐานการโอน' : 'Upload payment slip';
  String get slipUploadedSuccess =>
      isThai ? 'อัปโหลดสลิปสำเร็จ!' : 'Slip uploaded!';
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

  // Photo Permission Photo
  String get photoPermissionTitle => isThai ? 'ต้องการเข้าถึงรูปภาพ' : 'Photo Access Required';
  String get photoPermissionMsg => isThai
      ? 'Meri-Mari ต้องการเข้าถึงรูปภาพของคุณเพื่อใช้อัปโหลดเป็นรูปโปรไฟล์'
      : 'Meri-Mari needs access to your photos to upload as a profile picture.';
  String get allowLabel => isThai ? 'อนุญาต' : 'Allow';
  String get laterLabel => isThai ? 'ไว้ทีหลัง' : 'Not Now';

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
  String get confirmSetDefault => isThai
      ? 'ต้องการตั้งที่อยู่นี้เป็นที่อยู่หลักใช่หรือไม่?'
      : 'Set this as your primary address?';
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
  String get defaultLanguageSection =>
      isThai ? 'ภาษาเริ่มต้น' : 'System Default';
  String get otherLanguagesSection => isThai ? 'ภาษาอื่นๆ' : 'Other Languages';
  String get otherLanguagesHint => isThai
      ? 'ภาษาเหล่านี้ได้รับการแปลโดย ผู้ให้บริการอื่นๆ'
      : 'These languages are translated by other providers';
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
  String get communityRules => isThai ? 'กฎระเบียบในการใช้' : 'Usage Rules';
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

  // ── Notification Settings ─────────────────────────────────────────────────
  String get notificationSettings => isThai ? 'ตั้งค่าการแจ้งเตือน' : 'Notification Settings';
  String get pushNotifications => isThai ? 'การแจ้งเตือนในแอป' : 'Push Notifications';
  String get orderUpdates => isThai ? 'อัปเดตสถานะคำสั่งซื้อ' : 'Order Updates';
  String get promotions => isThai ? 'โปรโมชั่นและข้อเสนอ' : 'Promotions & Offers';
  String get chatMessages => isThai ? 'ข้อความแชท' : 'Chat Messages';

  // ── Shop Demo ─────────────────────────────────────────────────────────────
  String get openShop => isThai ? 'เปิดร้านค้า' : 'Open Shop';
  String get myShop => isThai ? 'ร้านค้าของฉัน' : 'My Shop';
  String get shopDemoMsg => isThai
      ? 'ฟีเจอร์ "ร้านค้าของฉัน" กำลังอยู่ระหว่างการพัฒนา\nขออภัยในความไม่สะดวก'
      : 'The "My Shop" feature is currently under development.\nWe apologize for any inconvenience.';

  String get helpCenterMsg => isThai
      ? 'ขณะนี้ระบบศูนย์ช่วยเหลือยังอยู่ในขั้นตอนการพัฒนา\nขออภัยในความไม่สะดวก'
      : 'The Help Center system is currently under development.\nWe apologize for any inconvenience.';

  String get contactSellerMsg => isThai
      ? 'เนื่องจากแอปนี้เป็นเพียงเวอร์ชัน Demo สินค้านี้จึงเป็นสินค้าตัวอย่างเท่านั้น\nขออภัยในความไม่สะดวก'
      : 'Since this app is only a Demo version, this product is for demonstration purposes only.\nWe apologize for any inconvenience.';

  // ── Policies ─────────────────────────────────────────────────────────────
  String get policiesPageTitle => isThai ? '[นโยบาย] นโยบายของ Meri-Mari' : '[Policies] Meri-Mari Policies';
  String get policiesPageSubtitle => isThai
      ? 'คุณสามารถศึกษาข้อมูลเพิ่มเติมเกี่ยวกับนโยบายต่างๆ ของ Meri-Mari ตามหัวข้อด้านล่างดังนี้'
      : 'You can learn more about various policies of Meri-Mari by the topics below.';
  String get policiesSectionTitle => isThai ? 'นโยบายของ Meri-Mari' : 'Meri-Mari Policies';
  
  String get clearCache => isThai ? 'เคลียร์ Cache' : 'Clear Cache';
  String get aboutTitle => isThai ? 'เกี่ยวกับ' : 'About';
  
  List<String> get usageRulesItems => isThai ? [
    'การเคารพสิทธิและความเป็นส่วนตัวของผู้อื่นในชุมชน Meri-Mari',
    'ห้ามลงขายสินค้าที่ผิดกฎหมาย หรือสินค้าต้องห้ามตามนโยบายของแอป',
    'การชำระเงินต้องทำผ่านช่องทาง PromptPay ที่กำหนดเท่านั้น เพื่อความปลอดภัย',
    'ห้ามใช้ถ้อยคำที่ไม่สุภาพ คุกคาม หรือเสียดสีผู้อื่นในระบบแชทติดต่อผู้ขาย',
    'ข้อมูลส่วนตัวและที่อยู่จัดส่งต้องเป็นความจริง และได้รับการอัปเดตเสมอ',
  ] : [
    'Respect the rights and privacy of others in the Meri-Mari community.',
    'Prohibit the sale of illegal items or items restricted by app policy.',
    'Payments must be made only through the specified PromptPay channels for security.',
    'Do not use impolite, threatening, or sarcastic language in the chat system.',
    'Personal information and shipping addresses must be true and kept updated.',
  ];
  
  List<String> get policyItems => isThai ? [
    'เงื่อนไขการให้บริการของ Meri-Mari',
    'นโยบายความเป็นส่วนตัวของ Meri-Mari',
    'นโยบายการคุ้มครองผู้ซื้อ (Buyer Protection System)',
    'ระบบการยืนยันสินค้าและการเคลม (Product Claims Policy)',
    'นโยบายการคืนเงินและคืนสินค้า',
    'แนวทางการแพ็คและจัดส่งสินค้าสะสม (Shipping Guidelines)',
    'นโยบายสิ่งของต้องห้ามและสิ่งของที่ถูกจำกัด',
    'แนวทางปฏิบัติการใช้งานชุมชน (Community Guidelines)',
  ] : [
    'Meri-Mari Terms of Service',
    'Meri-Mari Privacy Policy',
    'Buyer Protection System Policy',
    'Product Verification & Claims Policy',
    'Refund and Return Policy',
    'Collectible Packing & Shipping Guidelines',
    'Prohibited and Restricted Items Policy',
    'Meri-Mari Community Guidelines',
  ];

  // ── Feedback & Errors ───────────────────────────────────────────────────
  String get fillAllFields => isThai ? 'กรุณากรอกข้อมูลให้ครบถ้วน' : 'Please fill in all fields';
  String get passTooShort => isThai ? 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร' : 'Password must be at least 6 characters';
  String get emailAlreadyInUse => isThai ? 'อีเมลนี้ถูกใช้งานแล้ว' : 'This email is already in use';
  String get weakPassword => isThai ? 'รหัสผ่านง่ายเกินไป' : 'Password is too weak';
  String get invalidEmailOrPass => isThai ? 'Email หรือ Password ไม่ถูกต้อง' : 'Invalid email or password';
  String get tooManyAttempts => isThai ? 'ลองเข้าสู่ระบบบ่อยเกินไป' : 'Too many attempts. Try again later.';
  String get generalError => isThai ? 'เกิดข้อผิดพลาด' : 'An error occurred';
  String get uploadSuccessAwaitAdmin => isThai ? 'อัปโหลดสลิปสำเร็จ รอ Admin ตรวจสอบ' : 'Slip uploaded — awaiting admin verification.';
  String get uploadFailedPrefix => isThai ? 'เกิดข้อผิดพลาด: ' : 'Upload failed: ';
  String get demoNoticeTitle => isThai ? 'ประกาศ' : 'Notice';
  String get demoNoticeMsg => isThai
      ? 'เนื่องจากแอปพลิเคชันเป็นเพียง Version ทดลอง ทั้งตัวสินค้าและคิวอาร์โค้ดธนาคารล้วนเป็นข้อมูลชั่วคราวจำลองเท่านั้น จึงจะยังไม่มีการซื้อขายเกิดขึ้นจริงภายในแอปของเรา'
      : 'As this application is a Demo version, the products and bank QR codes are only mockups. No actual transactions or purchases will occur within our application.';
  String get payLaterNoticeMsg => isThai
      ? 'คำสั่งซื้อจะถูกบันทึกไว้ คุณสามารถชำระเงินภายหลังได้ในหน้าออเดอร์'
      : 'Your order will be saved and you can pay later from the orders page.';
  String get outOfStock => isThai ? 'สินค้าหมด' : 'Out of Stock';
  String get reserved => isThai ? 'สินค้าชิ้นนี้ถูกจองแล้ว' : 'This item is already reserved';
  String get unavailable => isThai ? 'ไม่สามารถสั่งซื้อได้' : 'Unavailable';
  String get addressRemoved => isThai ? 'ลบที่อยู่สำเร็จ' : 'Address removed';
  String get errorSendingEmail => isThai ? 'เกิดข้อผิดพลาดในการส่งอีเมล' : 'Error sending email';
  String get cancelOrderConfirmPrompt => isThai ? 'ยกเลิกออเดอร์?' : 'Cancel Order?';
  String get cancelOrderMsg => isThai ? 'หากยกเลิก สินค้าจะกลับมาให้ผู้อื่นสามารถสั่งซื้อได้อีกครั้ง' : 'The item will be available for others to purchase again.';
  String itemsCount(int n) => isThai ? 'สินค้ารวม $n รายการ: ' : '$n item(s): ';
  String get paymentExpired => isThai ? 'หมดเวลาชำระเงิน — ออเดอร์ถูกยกเลิก' : 'Payment expired — order cancelled';
  String get viaPromptPay => isThai ? ' ผ่าน QR พร้อมเพย์' : ' via QR PromptPay';
  String orderIdLabel(String id) => isThai ? 'รหัส: $id' : 'ID: $id';
  String get pendingPayment => isThai ? 'รอผู้ซื้อชำระเงิน' : 'Pending Payment';
  String get shippingStatus => isThai ? 'ผู้ขายกำลังจัดส่ง' : 'Shipping';
  String get toReceiveStatus => isThai ? 'รอรับสินค้า' : 'To Receive';
  String get successStatus => isThai ? 'สำเร็จ' : 'Success';
  String get noDeliveryAddressTitle => isThai ? 'ไม่มีที่อยู่จัดส่ง' : 'No Delivery Address';
  String get noDeliveryAddressMsg => isThai
      ? 'กรุณาเพิ่มที่อยู่จัดส่งในหน้าโปรไฟล์ หรือกดเลือกที่อยู่ก่อนทำการสั่งซื้อ'
      : 'Please add a delivery address or select one before placing your order.';
  String get totalPaymentLabel => isThai ? 'ยอดชำระเงินทั้งหมด' : 'Total Payment';
  String get reservationNotificationTitle => isThai ? 'จองสินค้าสำเร็จ' : 'Reservation Successful';
  String get reservationNotificationMsg => isThai 
      ? 'คุณได้ทำการจองสินค้าเรียบร้อยแล้ว รอการชำระเงิน' 
      : 'You have reserved the product successfully. Waiting for payment.';
}

