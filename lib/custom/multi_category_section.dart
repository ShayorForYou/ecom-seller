// import 'package:ecom_seller_app/data_model/product/category_view_model.dart';
// import 'package:ecom_seller_app/helpers/shimmer_helper.dart';
// import 'package:flutter/material.dart';
//
// import '../helpers/aiz_typedef.dart';
//
// class MultiCategory extends StatefulWidget {
//   MultiCategory(
//       {super.key,
//       required this.categories,
//       required this.isCategoryInit,
//       this.initialCategoryIds = const [],
//       this.initialMainCategory,
//       this.onSelectedCategories,
//       this.onSelectedMainCategory});
//
//   List<CategoryModel> categories;
//   bool isCategoryInit;
//   String? initialMainCategory;
//   List? initialCategoryIds;
//   GetString? onSelectedMainCategory;
//   GetStringArray? onSelectedCategories;
//
//   @override
//   State<MultiCategory> createState() => _MultiCategoryState();
// }
//
// class _MultiCategoryState extends State<MultiCategory> {
//   String? _selectedMainCategory;
//   List<String> _selectedCategoryIds = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     if (widget.initialMainCategory != null) {
//       _selectedMainCategory = widget.initialMainCategory;
//       widget.onSelectedMainCategory!(_selectedMainCategory!);
//     }
//
//     if (widget.initialCategoryIds != null &&
//         widget.initialCategoryIds!.isNotEmpty) {
//       _selectedCategoryIds
//           .addAll(widget.initialCategoryIds!.map((e) => e.toString()));
//
//       widget.onSelectedCategories!(_selectedCategoryIds);
//     }
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.isCategoryInit
//         ? _buildCategoryListView(widget.categories)
//         : SizedBox(
//             //   color: Colors.red,
//             height: 250,
//             child: ShimmerHelper().buildListShimmer(item_height: 16.0)
//             /*const Center(child:
//             CircularProgressIndicator()
//             )*/
//             );
//   }
//
//   _buildCategoryListView(List<CategoryModel> categories,
//       {double? padding, var height}) {
//     return Container(
//       height: height,
//       padding: EdgeInsets.only(left: padding ?? 0.0),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: RichText(
//                 text: const TextSpan(
//                   text: 'Main Category',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: ' *',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return SizedBox(
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.only(top: 10, right: 10),
//                         // color: Colors.yellow,
//                         child: Row(
//                           children: [
//                             // Container(
//                             //   margin: const EdgeInsets.only(right: 5),
//                             //   height: 20,
//                             //   width: 20,
//                             //   child: categories[index].children.isNotEmpty
//                             //       ? InkWell(
//                             //           onTap: () {
//                             //             if (categories[index].height == null) {
//                             //               categories[index].height = 0.0;
//                             //             } else {
//                             //               categories[index].height = null;
//                             //             }
//                             //             setChange();
//                             //           },
//                             //           child: Icon(
//                             //             categories[index].height != null
//                             //                 ? Icons.add
//                             //                 : Icons.remove,
//                             //             size: 18,
//                             //           ),
//                             //         )
//                             //       : const SizedBox.shrink(),
//                             // ),
//                             SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: Transform.scale(
//                                 scale: 0.7,
//                                 child: Checkbox(
//                                     value: _selectedCategoryIds
//                                         .contains(categories[index].id),
//                                     onChanged: (newValue) {
//                                       if (newValue ?? false) {
//                                         _selectedCategoryIds
//                                             .add(categories[index].id!);
//                                       } else {
//                                         _selectedCategoryIds
//                                             .remove(categories[index].id);
//                                       }
//
//                                       if (categories[index]
//                                           .children
//                                           .isNotEmpty) {
//                                         onSelectedCategory(
//                                             categories[index].children,
//                                             newValue ?? false);
//                                       }
//                                       setChange();
//                                     }),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 8,
//                             ),
//                             Text(
//                               categories[index].title ?? "",
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             const Spacer(),
//                             SizedBox(
//                               // color: Colors.red,
//                               height: 20,
//                               child: InkWell(
//                                 onTap: () {
//                                   _selectedMainCategory = categories[index].id;
//                                   setChange();
//                                 },
//                                 child: Transform.scale(
//                                   scale: 0.7,
//                                   child: Radio(
//                                       materialTapTargetSize:
//                                           MaterialTapTargetSize.shrinkWrap,
//                                       value: categories[index].id,
//                                       groupValue: _selectedMainCategory,
//                                       onChanged: (newValue) {
//                                         _selectedMainCategory = newValue;
//                                         setChange();
//                                       }),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       if (categories[index].children!.isNotEmpty)
//                         _buildCategoryListView(categories[index].children!,
//                             padding: 14.0, height: categories[index].height)
//                     ],
//                   ),
//                 );
//               },
//               separatorBuilder: (context, index) => const SizedBox(
//                     height: 0,
//                   ),
//               itemCount: categories.length),
//         ],
//       ),
//     );
//   }
//
//   onSelectedCategory(List<CategoryModel> categories, bool action) {
//     for (int index = 0; index < categories.length; index++) {
//       if (action) {
//         _selectedCategoryIds.add(categories[index].id!);
//         if (categories[index].children.isNotEmpty) {
//           onSelectedCategory(categories[index].children, action);
//         }
//       } else {
//         _selectedCategoryIds.remove(categories[index].id);
//         if (categories[index].children.isNotEmpty) {
//           onSelectedCategory(categories[index].children, action);
//         }
//       }
//     }
//   }
//
//   setChange() {
//     if (_selectedMainCategory != null) {
//       widget.onSelectedMainCategory!(_selectedMainCategory!);
//     }
//     if (_selectedCategoryIds.isNotEmpty) {
//       widget.onSelectedCategories!(_selectedCategoryIds);
//     }
//     setState(() {});
//   }
// }

import 'package:ecom_seller_app/data_model/product/category_view_model.dart';
import 'package:ecom_seller_app/helpers/shimmer_helper.dart';
import 'package:flutter/material.dart';

import '../helpers/aiz_typedef.dart';

class MultiCategory extends StatefulWidget {
  MultiCategory(
      {super.key,
      required this.categories,
      required this.isCategoryInit,
      this.initialCategoryIds = const [],
      this.initialMainCategory,
      this.onSelectedCategories,
      this.onSelectedMainCategory});

  List<CategoryModel> categories;
  bool isCategoryInit;
  String? initialMainCategory;
  List? initialCategoryIds;
  GetString? onSelectedMainCategory;
  GetStringArray? onSelectedCategories;

  @override
  State<MultiCategory> createState() => _MultiCategoryState();
}

class _MultiCategoryState extends State<MultiCategory> {
  String? _selectedMainCategory;
  List<String> _selectedCategoryIds = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialMainCategory != null) {
      _selectedMainCategory = widget.initialMainCategory;
      widget.onSelectedMainCategory?.call(_selectedMainCategory!);
    }

    if (widget.initialCategoryIds != null &&
        widget.initialCategoryIds!.isNotEmpty) {
      _selectedCategoryIds
          .addAll(widget.initialCategoryIds!.map((e) => e.toString()));
      widget.onSelectedCategories?.call(_selectedCategoryIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCategoryInit
        ? _buildCategoryListView(widget.categories)
        : SizedBox(
            height: 250,
            child: ShimmerHelper().buildListShimmer(item_height: 16.0),
          );
  }

  Widget _buildCategoryListView(List<CategoryModel> categories,
      {double? padding, var height}) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: padding ?? 0.0),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: const TextSpan(
                  text: 'Main Category',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final isChecked = _selectedCategoryIds
                                      .contains(categories[index].id);
                                  setState(() {
                                    if (isChecked) {
                                      _selectedCategoryIds
                                          .remove(categories[index].id);
                                    } else {
                                      _selectedCategoryIds
                                          .add(categories[index].id!);
                                    }

                                    if (categories[index].children.isNotEmpty) {
                                      onSelectedCategory(
                                          categories[index].children,
                                          !isChecked);
                                    }
                                  });
                                  setChange();
                                },
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.7,
                                      child: Checkbox(
                                        value: _selectedCategoryIds
                                            .contains(categories[index].id),
                                        onChanged: (newValue) {
                                          if (newValue ?? false) {
                                            _selectedCategoryIds
                                                .add(categories[index].id!);
                                          } else {
                                            _selectedCategoryIds
                                                .remove(categories[index].id);
                                          }

                                          if (categories[index]
                                              .children
                                              .isNotEmpty) {
                                            onSelectedCategory(
                                                categories[index].children,
                                                newValue ?? false);
                                          }
                                          setChange();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      categories[index].title ?? "",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 20,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedMainCategory =
                                            categories[index].id;
                                        setChange();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: 0.7,
                                      child: Radio(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: categories[index].id,
                                        groupValue: _selectedMainCategory,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedMainCategory = newValue;
                                            setChange();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (categories[index].children!.isNotEmpty)
                          _buildCategoryListView(categories[index].children!,
                              padding: 14.0, height: categories[index].height),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                itemCount: categories.length),
          ),
        ],
      ),
    );
  }

  void onSelectedCategory(List<CategoryModel> categories, bool action) {
    for (int index = 0; index < categories.length; index++) {
      if (action) {
        _selectedCategoryIds.add(categories[index].id!);
        if (categories[index].children.isNotEmpty) {
          onSelectedCategory(categories[index].children, action);
        }
      } else {
        _selectedCategoryIds.remove(categories[index].id);
        if (categories[index].children.isNotEmpty) {
          onSelectedCategory(categories[index].children, action);
        }
      }
    }
  }

  void setChange() {
    if (_selectedMainCategory != null) {
      widget.onSelectedMainCategory?.call(_selectedMainCategory!);
    }
    if (_selectedCategoryIds.isNotEmpty) {
      widget.onSelectedCategories?.call(_selectedCategoryIds);
    }
    setState(() {});
  }
}
