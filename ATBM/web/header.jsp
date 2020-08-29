<%@ page import="vn.edu.nlu.fit.model.User" %>
<%@ page import="vn.edu.nlu.fit.dao.ProductDAO" %>
<%@ page import="vn.edu.nlu.fit.model.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header id="main_header">
    <div class="container">
        <nav class="navbar navbar-expand-lg navbar-dark">
            <a class="navbar-brand" href="<%=Util.fullPath("home")%>">
                <i style="font-size: 45px; color: #fff" class="fab fa-speaker-deck"></i>
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse"
                    data-target="#navbarSupportedContentLG" aria-controls="navbarSupportedContentLG"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContentLG">
                <ul class="navbar-nav mr-auto">
                    <!--==========   MENU    ============-->
                    <jsp:include page="menu"/>
                </ul>
                <form action="<%=Util.fullPath("list_product")%>" method="get" class="mr-5" autocomplete="off">
                    <div class="input-group">
                        <input id="search" name="search" type="text" class="form-control pt-2"
                               style="border-start-start-radius: 20px"
                               placeholder="Nhập tên sản phẩm..." required=""
                               oninvalid="this.setCustomValidity('Bạn chưa nhập tên sản phẩm')"
                               oninput="setCustomValidity('')">
                        <div class="input-group-append">
                            <button class="btn btn-light" type="submit">
                                <i style="color: #ff6700" class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </form>
                <%--    LOGIN_LOGOUT    --%>
                <%
                    User ss = (User) session.getAttribute("user");
                    if (ss != null) {
                %>
                <a class="mr-3 text-decoration-none" href="<%=Util.fullPath("info")%>">
                    <%=ss.getFull_name().toUpperCase()%>
                </a>
                <a onclick="return logout()" href="#" class="text-decoration-none mr-3">ĐĂNG XUẤT</a>
                <%
                } else {
                %>
                <a id="login" class="mr-3 text-decoration-none" href="" data-toggle="modal"
                   data-target="#loginModal">ĐĂNG NHẬP</a>
                <a class="mr-3 text-decoration-none" href="" data-toggle="modal"
                   data-target="#regisModal">ĐĂNG KÍ</a>
                <%
                    }
                %>
                <%--    CART    --%>
                <a class="fas fa-shopping-cart mr-3 text-decoration-none" href="<%=Util.fullPath("show_cart")%>"
                   style="font-size: 20px; line-height: 45px"
                >
                </a>
            </div>
        </nav>
    </div>
</header>

<!--============== MODAL LOGIN ==============-->
<%@include file="login.jsp" %>

<!--============== MODAL REGIS ==============-->
<%@include file="register.jsp" %>

<script>
    function autocomplete(inp, arr) {
        /*the autocomplete function takes two arguments,
        the text field element and an array of possible autocompleted values:*/
        var currentFocus;
        /*execute a function when someone writes in the text field:*/
        inp.addEventListener("input", function (e) {
            var a, b, i, val = this.value;
            /*close any already open lists of autocompleted values*/
            closeAllLists();
            if (!val) {
                return false;
            }
            currentFocus = -1;
            /*create a DIV element that will contain the items (values):*/
            a = document.createElement("DIV");
            a.setAttribute("id", this.id + "autocomplete-list");
            a.setAttribute("class", "autocomplete-items");
            /*append the DIV element as a child of the autocomplete container:*/
            this.parentNode.appendChild(a);
            /*for each item in the array...*/
            for (i = 0; i < arr.length; i++) {
                /*check if the item starts with the same letters as the text field value:*/
                if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
                    /*create a DIV element for each matching element:*/
                    b = document.createElement("DIV");
                    /*make the matching letters bold:*/
                    b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
                    b.innerHTML += arr[i].substr(val.length);
                    /*insert a input field that will hold the current array item's value:*/
                    b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
                    /*execute a function when someone clicks on the item value (DIV element):*/
                    b.addEventListener("click", function (e) {
                        /*insert the value for the autocomplete text field:*/
                        inp.value = this.getElementsByTagName("input")[0].value;
                        /*close the list of autocompleted values,
                        (or any other open lists of autocompleted values:*/
                        closeAllLists();
                    });
                    a.appendChild(b);
                }
            }
        });
        /*execute a function presses a key on the keyboard:*/
        inp.addEventListener("keydown", function (e) {
            var x = document.getElementById(this.id + "autocomplete-list");
            if (x) x = x.getElementsByTagName("div");
            if (e.keyCode == 40) {
                /*If the arrow DOWN key is pressed,
                increase the currentFocus variable:*/
                currentFocus++;
                /*and and make the current item more visible:*/
                addActive(x);
            } else if (e.keyCode == 38) { //up
                /*If the arrow UP key is pressed,
                decrease the currentFocus variable:*/
                currentFocus--;
                /*and and make the current item more visible:*/
                addActive(x);
            } else if (e.keyCode == 13) {
                /*If the ENTER key is pressed, prevent the form from being submitted,*/
                e.preventDefault();
                if (currentFocus > -1) {
                    /*and simulate a click on the "active" item:*/
                    if (x) x[currentFocus].click();
                }
            }
        });

        function addActive(x) {
            /*a function to classify an item as "active":*/
            if (!x) return false;
            /*start by removing the "active" class on all items:*/
            removeActive(x);
            if (currentFocus >= x.length) currentFocus = 0;
            if (currentFocus < 0) currentFocus = (x.length - 1);
            /*add class "autocomplete-active":*/
            x[currentFocus].classList.add("autocomplete-active");
        }

        function removeActive(x) {
            /*a function to remove the "active" class from all autocomplete items:*/
            for (var i = 0; i < x.length; i++) {
                x[i].classList.remove("autocomplete-active");
            }
        }

        function closeAllLists(elmnt) {
            /*close all autocomplete lists in the document,
            except the one passed as an argument:*/
            var x = document.getElementsByClassName("autocomplete-items");
            for (var i = 0; i < x.length; i++) {
                if (elmnt != x[i] && elmnt != inp) {
                    x[i].parentNode.removeChild(x[i]);
                }
            }
        }

        /*execute a function when someone clicks in the document:*/
        document.addEventListener("click", function (e) {
            closeAllLists(e.target);
        });
    }

    /*An array containing all the country names in the world:*/
    <%
    String text = "";
    ProductDAO auto  = new ProductDAO();
    ArrayList<Product> arr = auto.listProduct();
    for(Product pro: arr){
        text+= "\""+pro.getProduct_name()+"\""+", ";
    }
    %>
    var product = [<%=text%>];
    /*initiate the autocomplete function on the "myInput" element, and pass along the countries array as possible autocomplete values:*/
    autocomplete(document.getElementById("search" +
        ""), product);

</script>

<style>

    /*the container must be positioned relative:*/
    .autocomplete {
        position: relative;
        display: inline-block;
    }


    .autocomplete-items {
        position: absolute;
        border: 1px solid #d4d4d4;
        border-bottom: none;
        border-top: none;
        z-index: 99;
        overflow: scroll;
        height: 300px;
        /*position the autocomplete items to be the same width as the container:*/
        top: 100%;
        left: 0;
        right: 0;
    }

    .autocomplete-items div {
        padding: 10px;
        cursor: pointer;
        background-color: #fff;
        border-bottom: 1px solid #d4d4d4;
    }

    /*when hovering an item:*/
    .autocomplete-items div:hover {
        background-color: #e9e9e9;
    }

    /*when navigating through the items using the arrow keys:*/
    .autocomplete-active {
        background-color: DodgerBlue !important;
        color: #ffffff;
    }
</style>