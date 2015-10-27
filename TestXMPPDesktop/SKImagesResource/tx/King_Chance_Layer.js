// JavaScript Document
$(document).ready(function(){
	var $King_Chance_LayerCont = $(".King_Chance_LayerCont");
	var $King_Chance_Layer_Close = $(".King_Chance_Layer_Close");
	var $King_Chance_Layer_Btn = $(".King_Chance_Layer_Btn > ul > li");
	var $King_Chance_Layer_Content = $(".King_Chance_Layer_Content > ul > li");
	var King_Chance_Layer_Btn_Hover = "hover";
	var King_Chance_Layer_Show_Num = 0;
	var King_Chance_Layer_Btn_Len = $King_Chance_Layer_Btn.length;
	$King_Chance_Layer_Btn.hover(function(){
		var King_Chance_Layer_Show_Num = $King_Chance_Layer_Btn.index(this);
		$(this).addClass(King_Chance_Layer_Btn_Hover).siblings().removeClass(King_Chance_Layer_Btn_Hover);
		$King_Chance_Layer_Content.eq(King_Chance_Layer_Show_Num).show().siblings().hide();
		$King_Chance_Layer_Content.eq(King_Chance_Layer_Show_Num).find("img").lazyload();
		});
	var King_Chance_Layer_Play = function(){
		King_Chance_Layer_Show_Num++;
		if(King_Chance_Layer_Show_Num>=King_Chance_Layer_Btn_Len) King_Chance_Layer_Show_Num=0;
		$King_Chance_Layer_Btn.eq(King_Chance_Layer_Show_Num).addClass(King_Chance_Layer_Btn_Hover).siblings().removeClass(King_Chance_Layer_Btn_Hover);
		$King_Chance_Layer_Content.eq(King_Chance_Layer_Show_Num).show().siblings().hide();
		$King_Chance_Layer_Content.eq(King_Chance_Layer_Show_Num).find("img").lazyload();
		};
	
	$King_Chance_Layer_Close.click(function(){clearInterval(King_Chance_Layer_Play_Time);$King_Chance_LayerCont.slideUp();});
	King_Chance_Layer_Pop = function(){
		$King_Chance_LayerCont.slideDown();
		$King_Chance_Layer_Btn.eq(King_Chance_Layer_Show_Num).addClass(King_Chance_Layer_Btn_Hover);
		$King_Chance_Layer_Content.eq(King_Chance_Layer_Show_Num).show();
		King_Chance_Layer_Play_Time = setInterval(function(){King_Chance_Layer_Play();},2000);
		};
	});
var scripts=document.getElementsByTagName("script"),script=scripts[scripts.length-1];
strJsPath=document.querySelector?script.src:script.getAttribute("src",4);
strJsPath = strJsPath.substring(0,strJsPath.lastIndexOf("/"))+"/";
function King_Chance_Layer_Probability(King_Chance_Layer_Array){
	var King_Chance_Layer_Array_Num=0,King_Chance_Layer_Array_Rnd,King_Chance_Layer_Array_NewRnd=0;
	for(i=0;i<King_Chance_Layer_Array.length;i++){King_Chance_Layer_Array_Num += King_Chance_Layer_Array[i];};
	var King_Chance_Layer_Array_Rnd=Math.round((King_Chance_Layer_Array_Num - 1) * Math.random()) + 1;
	if(King_Chance_Layer_Array_Rnd<=0) return false;
	for(i=0;i<King_Chance_Layer_Array.length;i++){
		King_Chance_Layer_Array_NewRnd += King_Chance_Layer_Array[i];
		if(King_Chance_Layer_Array_Rnd<=King_Chance_Layer_Array_NewRnd){
			$("head").append("<link rel='stylesheet' type='text/css' href='"+strJsPath+"King_Chance_Layer"+(i+1)+".css'>");
			if(window.addEventListener){window.addEventListener("load",King_Chance_Layer_Pop,false);}
			else{window.attachEvent("onload",King_Chance_Layer_Pop);};
			break;
			};
		};
	};
//批量延迟加载
//for(var i=0 ; i < imgs.length; i++){
//	var _top = getTop(imgs[i]),_left = getLeft(imgs[i]);
//	//判断图片是否在显示区域内
//	if( _top >= top &&
//		_left >= left &&
//		_top <= top+height &&
//		_left <= left+width){
//		var _src = imgs[i].getAttribute('_src');
//		//如果图片已经显示，则取消赋值
//		if(imgs[i].src !== _src){
//			imgs[i].src = _src;
//		}
//	}
//}