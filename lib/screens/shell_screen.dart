import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/routes/app_router.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';


class ShellScreen extends ConsumerStatefulWidget {
  final Widget? child;
  const ShellScreen({super.key, this.child});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}


class _ShellScreenState extends ConsumerState<ShellScreen>  {
 // var title="My Favorites";
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon( Icons.store_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
             icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorites',
          )
        ],
        onTap: (index) {
  if (index == 0) {
    context.goNamed(AppRouter.product.name);
  } else if (index == 1) {
    context.goNamed(AppRouter.cart.name);
  } else if (index == 2) {
    context.goNamed(AppRouter.favorites.name);
  }
},

        



      ),
      body: widget.child,
      appBar: widget.child?.appBar,

      
    );
      
      

  }
  //  title = ref.watch(appTitleNotifierProvider);
//     AppBar customAppBar;

// if (title.toLowerCase() == "favorites") {
//   customAppBar = AppBar(
//     title: const Text(
//       "My Favorites",
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 30,
//         letterSpacing: 1.5,
//       ),
//     ),
//     actions: [
//       IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
//     ],
//   );
// } else {
//   customAppBar = AppBar(
//     title: Text(title),
//     backgroundColor: Colors.blue,
//     actions: [
//       IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
//     ],
//   );
// }
    // return Scaffold(
    //  // appBar: customAppBar,
    //   bottomNavigationBar: Row(
    //     children: [
    //       BottomNavigationBar(
    //         items: [
    //           BottomNavigationBarItem(icon: IconButton(onPressed: (){
          
    //           }, icon: Icon(Icons.favorite,
    //           ),
    //           ),
    //           ),
    //           BottomNavigationBarItem(icon: IconButton(onPressed: (){
          
    //           }, icon: Icon(Icons.home,
    //           ),
    //           ),
    //           ),
    //           BottomNavigationBarItem(icon: IconButton(onPressed: (){
          
    //           }, icon: Icon(Icons.trolley,
    //           ),
    //           ),
    //           )
    //         ],
    //       ),
    //     ],
    //   ),


    // );
  }
  
  extension on Widget? {
  get appBar => null;
  }


