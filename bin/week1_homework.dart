import 'dart:io';

class Product {
  final String name;
  final int price;

  Product({required this.name, required this.price});
}

class ShoppingMall {
  final List<Product> products = [
    Product(name: '셔츠', price: 45000),
    Product(name: '원피스', price: 30000),
    Product(name: '반팔티', price: 35000),
    Product(name: '반바지', price: 38000),
    Product(name: '양말', price: 5000),
  ];
  Map<String, int> cart = {}; //장바구니
  List<String> cartList = [];

  // 판매하는 상품목록 List<Product>
  void showProducts() {
    for (var product in products) {
      print('${product.name} / ${product.price}원');
    }
  } // 상품 목록을 출력하는 메서드

  void addToCart() {
    try {
      print("상품 이름을 입력해 주세요!");
      String? productName = stdin.readLineSync();

      // 입력값이 null이거나 빈 값일 경우
      if (productName == null || productName.isEmpty) {
        print("입력값이 올바르지 않아요!");
        return;
      }

      // 상품이 존재하는지 확인
      final product = products.firstWhere(
        (p) => p.name == productName,
        orElse: () => Product(name: '', price: 0),
      );

      if (product.name.isEmpty) {
        print("입력값이 올바르지 않아요!");
        return;
      }

      print("상품 개수를 입력해 주세요!"); // 동기방식이기 때문에, 이 다음에 입력하도록 함.
      String? quantityInput = stdin.readLineSync();
      int quantity = int.tryParse(quantityInput ?? '') ?? 0;
      // int.parse로 쓰면 사용자가 문자를 입력하면 충돌 일어남. 이에 null값을 처리할 수 있는 tryParse 사용. 입력값이 null일 경우 빈문자열을 반환하고, int값으로 변환했는데 null 이라면 0으로 반환하도록 조건표현식 ?? 사용.

      if (quantity <= 0) {
        print("0개보다 많은 개수의 상품만 담을 수 있어요!");
        return;
      }

      // 장바구니에 추가
      cartList.add(productName);
      cart[productName] = (cart[productName] ?? 0) + quantity;
      // productName에 해당하는 기존 개수를 불러오고, null이라면 0으로 설정 후 갯수 더하기. 처음 입력시 상품명을 입력했으니, cart 내에 상품명이 일치하는지 여부를 확인하는게 우선임. 그런 후 기존 cart에 저장함. 즉, cart["상품명"] = 입력갯수;로 저장되는거.
      print("장바구니에 상품이 담겼어요!");
    } catch (e) {
      print('발생한 예외는? $e');
    }
  } // 상품을 장바구니에 담는 메서드.

  void showTotal() {
    if (cart.isEmpty) {
      print('장바구니가 비었습니다.');
      return; // 이거 안썼더니 0원 담겼다는 문구도 같이 나오네
    }
    String list = cartList.join(', ');
    int total = 0;
    cart.forEach((key, value) {
      final product = products.firstWhere(
        (p) => p.name == key,
        orElse: () => Product(name: '', price: 0),
      );
      total += product.price * value;
      // print('상품명 : $key, 상품 가격 : $price원, 장바구니 개수 : $value개'); 확인용.
    });
    print('\n장바구니에 ' + list + '가 담겨있네요. 총 $total원 입니다!');
  } // 장바구니에 담은 상품의 총 가격을 출력하는 메서드

  void clearCart() {
    cart.clear(); // 변수값을 어떻게 하는지는 모르겠고, 그냥 clear 하면 되는거 아닌가
  }
}

void main() {
  String? input; // input이라는 변수를 선언해줘야 함. 단, do-while문 밖에. 그래야 무한루프 안돔.
  ShoppingMall shoppingMall = ShoppingMall();
  print("콘솔 쇼핑몰 시-작!"); // 확인용. 처음 1회만

  do {
    print(
      "[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료",
    );
    String? input = stdin.readLineSync();
    // do(루프)가 시작되고, 입력값을 기다림. 근데, 입력값을 기다리는 행위가 밖에 있으면, 루프가 종료될 때까지 값을 입력못함. 즉, 입력받은 값이 do 안에 있어야함.
    if (input == "1") {
      shoppingMall.showProducts();
    } else if (input == "2") {
      shoppingMall.addToCart();
    } else if (input == "3") {
      shoppingMall.showTotal();
    } else if (input == "4") {
      print("정말 종료하시겠습니까?"); // 동기방식이기 때문에, 이 다음에 입력하도록 함.
      String? coloseInput = stdin.readLineSync();
      if (coloseInput == "5") {
        print("이용해 주셔서 감사합니다~ 안녕히 가세요!");
        break;
      }
      print("종료하지 않습니다.");
    } else if (input == "6") {
      shoppingMall.clearCart();
    } else {
      print("지원하지 않는 기능입니다! 다시 시도해주세요.");
    }
  } while (input != "4");
}
