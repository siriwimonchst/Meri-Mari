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
  String get forgotPassword => isThai ? 'ลืมรหัสผ่าน?' : 'FORGOT';

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
  String get tagMISB => isThai ? 'MISB' : 'MISB';
  String get tagCheckCard => isThai ? 'เช็คการ์ด' : 'Check Card';

  /// Stable internal keys used when filtering & stored locally.
  /// These are what predefinedTags uses as 'key'.
  static const String kTagNoDefect = 'no_defect';
  static const String kTagBrandNew = 'brand_new';
  static const String kTagPreOwned = 'pre_owned';
  static const String kTagMISB = 'misb';
  static const String kTagCheckCard = 'check_card';

  /// All predefined filter tags (key = stable internal key, label = localized).
  List<Map<String, String>> get predefinedTags => [
    {'key': kTagNoDefect, 'label': tagNoDefect},
    {'key': kTagBrandNew, 'label': tagBrandNew},
    {'key': kTagPreOwned, 'label': tagPreOwned},
    {'key': kTagMISB, 'label': tagMISB},
    {'key': kTagCheckCard, 'label': tagCheckCard},
  ];

  /// Transforms any tag value from Firestore into the app's current language.
  /// Recognizes canonical keys, Thai names, English names, and legacy spellings.
  String tagLabel(String raw) {
    switch (raw.trim().toLowerCase()) {
      // No Defect
      case 'no_defect':
      case 'ไม่มีตำหนิ':
      case 'no defect':
      case 'nodefect':
        return tagNoDefect;

      // Brand New / มือ 1
      case 'brand_new':
      case 'มือ 1':
      case 'มือ1':
      case 'brand new':
      case 'brandnew':
      case 'new':
        return tagBrandNew;

      // Pre-owned / มือ 2
      case 'pre_owned':
      case 'มือ 2':
      case 'มือ2':
      case 'pre-owned':
      case 'pre owned':
      case 'preowned':
      case 'used':
        return tagPreOwned;

      // MISB
      case 'misb':
        return tagMISB;

      // Check Card
      case 'check_card':
      case 'check card':
      case 'checkcard':
      case 'check-card':
      case 'เช็คการ์ด':
      case 'เช็คการด':
        return tagCheckCard;

      default:
        return raw; // unknown tag — show as-is
    }
  }

  // ── Product Detail ────────────────────────────────────────────────────────
  String get addToCart => isThai ? 'เพิ่มในตะกร้า' : 'Add to Cart';
  String get buyNow => isThai ? 'ซื้อเลย (Escrow)' : 'Buy Now (Escrow)';
  String get collection => isThai ? 'คอลเลกชัน' : 'Collection';
  String get condition => isThai ? 'สภาพสินค้า' : 'Condition';
  String get tagsLabel => isThai ? 'แท็กสินค้า' : 'Tags';
  String get shipping => isThai ? 'ค่าจัดส่งโดยประมาณ' : 'Est. Shipping';
  String get details => isThai ? 'รายละเอียดเพิ่มเติม' : 'Details';
  String get productDesc => isThai
      ? 'สินค้าลิขสิทธิ์แท้ 100% จัดส่งผ่านระบบคนกลาง (Escrow) เงินของคุณจะถูกโอนให้ผู้ขายเมื่อตรวจสอบสินค้าแล้วเท่านั้น'
      : '100% authentic. Shipped via Escrow — your payment is released to the seller only after you confirm receipt.';
  String get addedToCart => isThai ? 'เพิ่มในตะกร้าแล้ว!' : 'Added to cart!';

  // ── Cart ─────────────────────────────────────────────────────────────────
  String get cart => isThai ? 'ตะกร้าสินค้า' : 'Cart';
  String get emptyCart => isThai ? 'ตะกร้าว่างเปล่า' : 'Your cart is empty';
  String get removeFromCart => isThai ? 'ลบออก' : 'Remove';
  String get checkout => isThai ? 'ชำระเงิน' : 'Checkout';
  String get total => isThai ? 'รวมทั้งหมด' : 'Total';
  String get subtotal => isThai ? 'ราคาสินค้า' : 'Subtotal';
  String get orderSummary => isThai ? 'สรุปคำสั่งซื้อ' : 'Order Summary';
  String get shippingCost => isThai ? 'ค่าจัดส่ง' : 'Shipping Cost';
  String get totalPayment => isThai ? 'ยอดชำระทั้งหมด' : 'Total Payment';
  String get selectAll => isThai ? 'เลือกทั้งหมด' : 'Select all';
  String get orders => isThai ? 'ออเดอร์' : 'Orders';
  // Checkout
  String get placeOrder => isThai ? 'สั่งซื้อ' : 'Place Order';
  String get deliveryAddress => isThai ? 'ที่อยู่จัดส่ง' : 'Delivery Address';
  String get paymentMethod => isThai ? 'ช่องทางชำระเงิน' : 'Payment Method';
  String get qrPromptPay => isThai ? 'QR พร้อมเพย์' : 'QR PromptPay';
  String get scanQrToPay => isThai ? 'สแกน QR เพื่อชำระเงิน' : 'Scan QR to Pay';
  String get payLater => isThai ? 'ชำระภายหลัง' : 'Pay later';
  String get uploadSlip =>
      isThai ? 'อัพโหลดสลิปชำระเงิน' : 'Upload payment slip';
  String get waitingVerification =>
      isThai ? 'รอการตรวจสอบชำระเงิน' : 'Awaiting payment verification';
  String get checkoutTitle => isThai ? 'ทำการสั่งซื้อ' : 'Checkout';
  String get totalItems => isThai ? 'สินค้ารวม' : 'Total items';
  String get reviewOrder => isThai ? 'ตรวจสอบคำสั่งซื้อ' : 'Review Order';
  // Orders tabs
  String get tabToPay => isThai ? 'ที่ต้องชำระ' : 'To Pay';
  String get tabToShip => isThai ? 'ที่ต้องจัดส่ง' : 'To Ship';
  String get tabToReceive => isThai ? 'ที่ต้องได้รับ' : 'To Receive';
  String get tabToRate => isThai ? 'ให้คะแนน' : 'To Rate';
  String get emptyOrders => isThai ? 'ยังไม่มีออเดอร์' : 'No orders yet';

  // ── Favorites ─────────────────────────────────────────────────────────────
  String get myFavorites => isThai ? 'สินค้าที่ชอบ' : 'My Favorites';
  String get emptyFavorites =>
      isThai ? 'ยังไม่มีสินค้าที่ชอบ' : 'No favorites yet';
  String get unFavorite => isThai ? 'เลิกชอบ' : 'UnFavorite';

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
  String get language => isThai ? 'ภาษา' : 'Language';
  String get languageValue => isThai ? 'ภาษาไทย' : 'English UK';
  String get logout => isThai ? 'ออกจากระบบ' : 'Logout';
  String get emailStatus => isThai ? 'สถานะอีเมล' : 'Email Status';
  String get verified => isThai ? 'ยืนยันแล้ว ✓' : 'Verified ✓';
  String get notVerified => isThai ? 'ยังไม่ยืนยัน' : 'Not verified';
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
  String get saveChanges => isThai ? 'บันทึกการเปลี่ยนแปลง' : 'Save changes';
  String get setAsDefaultLabel =>
      isThai ? 'ตั้งเป็นที่อยู่ปัจจุบัน' : 'Set as default address';
  // Home
  String get emptyCartHint =>
      isThai ? 'เพิ่มสินค้าจากหน้าหลัก' : 'Add items from Home';
  String get favHint =>
      isThai ? 'กดหัวใจบนสินค้าที่ชอบ' : 'Tap ♥ on a product you like';
  // Cart clear
  String get clearAll => isThai ? 'ล้างทั้งหมด' : 'Clear all';

  // ── Nav ───────────────────────────────────────────────────────────────────
  String get home => isThai ? 'หน้าหลัก' : 'Home';
  String get explore => isThai ? 'ค้นหา' : 'Explore';
  String get favorites => isThai ? 'ถูกใจ' : 'Favorites';
  String get navProfile => isThai ? 'โปรไฟล์' : 'Profile';
  String get navOrders => isThai ? 'ออเดอร์' : 'Orders';
}
