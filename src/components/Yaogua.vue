<template>
  <div id="gen">
    <div class='guamethods'>
      <span>起卦方式: </span> 
      <input type='radio' id='hand' v-bind:value='1' v-model='guaMethod' v-on:change='init'>
      <label for='hand' class='checkable'>摇卦</label>
      <input type='radio' id='yangtime' v-bind:value='2' v-model='guaMethod' v-on:change='getGua( timenow )'>
      <label for='yangtime' class='checkable'>公历时间</label>
      <input type='radio' id='yintime' v-bind:value='3' v-model='guaMethod' v-on:change='getGua( timenow )'>
      <label for='yintime' class='checkable'>农公时间</label>
      <span>占事: </span>
      <select class='zhanshi' v-model='guaType'>
        <option value='0'>预测婚姻</option>
        <option value='1'>预测比赛</option>
        <option value='2'>预测天气</option>
        <option value='3'>预测财运</option>
        <option value='4'>预测合作</option>
        <option value='5'>预测出行</option>
        <option value='6'>预测行人</option>
        <option value='7'>预测失物</option>
        <option value='8'>预测学业</option>
        <option value='9'>预测事业</option>
      </select>

      <button type="button" class="btn btn-primary" @click="getGua( timenow )" v-bind:disabled='isDisabled' :class="{ disabled: guaMethod !=1 }"> 掷铜钱</button>
      <div :class="{ disabled: guaMethod == 1 } " class='datenow'>
        <flat-pickr :config='config' v-model='timenow' @on-close='getGua( timenow )'></flat-pickr>
      </div>
    </div>

    <hr/>
    <table class='tabyaogua'>
      <tr>
        <th>摇卦时间</th>
        <td>{{ datenow }}</td>
      </tr>
      <tr>
        <th>农历时间</th>
        <td>{{ lunarDateNow }}</td>
      </tr>
      <tr>
        <th>干      支</th>
        <td>{{ ganzhiNow }}</td>
      </tr>
      <tr>
        <th>神      煞</th>
        <td>{{ shenShaNow }}</td>
      </tr>
    </table>
    <hr />
    <table class='tabguaxiang'>
      <tr>
        <th>  六     神 </th>
        <th class="tooltip-top" data-tooltip="代表事物的开始">  本      卦</th>
        <th class="tooltip-top" data-tooltip="代表事物的结果">  变      卦</th>
      </tr>
      <tr>
        <td></td>
        <td> {{ benGuaGong }}<router-link :to="{ path:'/knowledge', query:{ q: benGuaOrder } }">{{ benGua['name'] }}</router-link></td>
        <td> {{ bianGuaGong }}<router-link :to="{ path:'/knowledge', query:{ q: bianGuaOrder } }">{{ bianGua['name'] }}</router-link></td>
      </tr>
      <tr>
        <td> 
          <ul class='flex one show'>
            <li v-for='(item,key) in liuShen' class='stack' :key='key.id'>
              <span class='guainfo'>{{ item }}</span>
            </li>
          </ul>
        </td>
        <td>
          <ul class='flex one show'>
            <li v-for='(yao,key) in res' class='stack' :key='yao.id'>
              <span v-if='yao=="x"||yao=="\""' class='guainfo'>{{ benLiuQin[key] }}{{ benGan[key] }}{{ benZhi[key] }}{{ benWuXing[key] }}</span>
              <span v-if='yao=="x"||yao=="\""' class='yin'></span>
              <span v-if="yao=='o'||yao=='\''" class='guainfo'>{{ benLiuQin[key] }}{{ benGan[key] }}{{ benZhi[key] }}{{ benWuXing[key] }}</span>
              <span v-if="yao=='o'||yao=='\''" class='yang'></span>
              <span v-if='6-key==benShi' class='shiying' :class="{ disabled: !isDisabled}">世</span>
              <span v-if='6-key==benYing' class='shiying' :class="{ disabled: !isDisabled}">应</span>
              <span v-if='yao=="x"'>{{ yao }}</span>
              <span v-if='yao=="o"'>{{ yao }}</span>
            </li>
          </ul>
        </td>
        <td>
          <ul class='flex one show' :class="{ disabled: !isDisabled}">
            <li v-for='(yao,key) in res' class='stack' :key='yao.id'>
              <span v-if='yao=="o"||yao=="\""' class='guainfo'>{{ bianLiuQin[key] }}{{ bianGan[key] }}{{ bianZhi[key] }}{{ bianWuXing[key] }}</span>
              <span v-if='yao=="o"||yao=="\""' class='yin'></span>
              <span v-if="yao=='x'||yao=='\''" class='guainfo'>{{ bianLiuQin[key] }}{{ bianGan[key] }}{{ bianZhi[key] }}{{ bianWuXing[key] }}</span>
              <span v-if="yao=='x'||yao=='\''" class='yang'></span>
              <span v-if='6-key==bianShi' class='shiying' :class="{ disabled: !isDisabled}">世</span>
              <span v-if='6-key==bianYing' class='shiying' :class="{ disabled: !isDisabled}">应</span>
            </li>
          </ul>
        </td>
      </tr>
    </table>
    <hr>
    <jieGua :guaType='guaType' :guaData='guaData' />
    <hr>
    <div>
      <ul>
        <li>按公历时间起卦（规则是：公历（年+月+日+时）除以８取余数做上卦，（年+月+日+时+分）除以８取余数做下卦，（年+月+日+时+分）除以６取余数做动爻）</li>
        <li>按农历时间起卦，也即是传统的时间起卦方法，农历（年支数+月+日）除以８取余数做上卦，（年支数+月+日+时支数）除以８取余数做下卦，（年支数+月+日+时支数）除以６取余数做动爻）</li>
        <li>时间起卦都是按照先天八卦顺序: 乾1, 兑2, 离3, 震4, 巽5, 坎6, 艮7, 坤8.</li>
        <li>地支数: 子1, 丑2, 寅4, 卯4, 辰5, 巳6, 午7, 未8, 申9, 酉10, 戌11, 亥12.</li>
      </ul>
    </div>
  </div>
</template>
<script>
import jieGua from './Jiegua.vue';
const gen = require('random-seed');
const solarLunar = require('solarLunar');
const flatPickr = require('vue-flatpickr-component');
const Chinese = require('flatpickr/dist/l10n/zh.js').default.zh;
const tianGan = {1:'甲', 2:'乙', 3:'丙', 4:'丁', 5:'戊', 6:'己', 7:'庚', 8:'辛', 9:'壬', 10:'癸'};
const diZhi = {1:'子', 2:'丑', 3:'寅', 4:'卯', 5:'辰', 6:'巳', 7:'午', 8:'未', 9:'申', 10:'酉', 11:'戌', 12:'亥'};
//const shengXiao={1:'鼠', 2:'牛', 3:'虎', 4:'兔', 5:'龙', 6:'蛇', 7:'马', 8:'羊', 9:'猴', 10:'鸡', 11:'狗', 12:'猪'};
const liuQin = {1:'子孙', 2:'妻财', 3:'父母', 4:'官鬼', 5:'兄弟'}
const wuXing = {1:'木', 2:'火', 3:'土', 4:'金', 5:'水'}
const liuShenDic = {1:'玄武', 2:'青龙', 3:'朱雀',	4:'勾陈',	5:'螣蛇',	6:'白虎'};
const xianTianBaGua = { 1: '111', 6: '010', 7: '001', 4: '100', 5: '011', 3: '101', 8: '000', 2: '110' };
//bagua = {1:'乾', 2:'坎', 3:'艮', 4:'震', 5:'巽', 6:'离', 7:'坤', 8:'兑'};
//baguagan = {9:'乾上', 1:'乾下', 5:'坎', 3:'艮', 7:'震', 8:'巽', 6:'离', 2:'坤下', 4:'兑',10:'坤上'};
//1=yang, 0=yin
const liuShiSiGua={ 
  63: { gong:'乾', name:'乾为天'  , shi:6, ying:3, liuqin:[1,2,3,4,5,3], gan:[ 1, 1, 1, 9, 9, 9], zhi:[ 1, 3, 5, 7, 9,11], wuxing:[5,1,3,2,4,3] },
  31: { gong:'乾', name:'天风姤'  , shi:1, ying:4, liuqin:[3,1,5,4,5,3], gan:[ 8, 8, 8, 9, 9, 9], zhi:[ 2,12,10, 7, 9,11], wuxing:[3,5,4,2,4,3] },
  15: { gong:'乾', name:'天山遯'  , shi:2, ying:5, liuqin:[3,4,5,4,5,3], gan:[ 3, 3, 3, 9, 9, 9], zhi:[ 5, 7, 9, 7, 9,11], wuxing:[3,2,4,2,4,3] },
  7: { gong:'乾', name:'天地否'  , shi:3, ying:6, liuqin:[3,4,2,4,5,3], gan:[ 2, 2, 2, 9, 9, 9], zhi:[ 8, 6, 4, 7, 9,11], wuxing:[3,2,1,2,4,3] },
  3: { gong:'乾', name:'风地观'  , shi:4, ying:1, liuqin:[3,4,2,3,4,2], gan:[ 2, 2, 2, 8, 8, 8], zhi:[ 8, 6, 4, 8, 6, 4], wuxing:[3,2,1,3,2,1] },
  1: { gong:'乾', name:'山地剥'  , shi:5, ying:2, liuqin:[3,4,2,3,1,2], gan:[ 2, 2, 2, 3, 3, 3], zhi:[ 8, 6, 4,11, 1, 3], wuxing:[3,2,1,3,5,1] },
  5: { gong:'乾', name:'火地晋'  , shi:4, ying:1, liuqin:[3,4,2,5,3,4], gan:[ 2, 2, 2, 6, 6, 6], zhi:[ 8, 6, 4,10, 8, 6], wuxing:[3,2,1,4,3,2] },
  61: { gong:'乾', name:'火天大有', shi:3, ying:6, liuqin:[1,2,3,5,3,4], gan:[ 1, 1, 1, 6, 6, 6], zhi:[ 1, 3, 5,10, 8, 6], wuxing:[5,1,3,4,3,2] },
  18: { gong:'坎', name:'坎为水'  , shi:6, ying:3, liuqin:[1,4,2,3,4,5], gan:[ 5, 5, 5, 5, 5, 5], zhi:[ 3, 5, 7, 9,11, 1], wuxing:[1,3,2,4,3,5]},
  50: { gong:'坎', name:'水泽节'  , shi:1, ying:4, liuqin:[2,1,4,3,4,5], gan:[ 4, 4, 4, 5, 5, 5], zhi:[ 6, 4, 2, 9,11, 1], wuxing:[2,1,3,4,3,5] },
  34: { gong:'坎', name:'水雷屯'  , shi:2, ying:5, liuqin:[5,1,4,3,4,5], gan:[ 7, 7, 7, 5, 5, 5], zhi:[ 1, 3, 5, 9,11, 1], wuxing:[5,1,3,4,3,5] },
  42: { gong:'坎', name:'水火既济', shi:3, ying:6, liuqin:[1,4,5,3,4,5], gan:[ 6, 6, 6, 5, 5, 5], zhi:[ 4, 2,12, 9,11, 1], wuxing:[1,3,5,4,3,5] },
  46: { gong:'坎', name:'泽火革'  , shi:4, ying:1, liuqin:[1,4,5,5,3,4], gan:[ 6, 6, 6, 4, 4, 4], zhi:[ 4, 2,12,12,10, 8], wuxing:[1,3,5,5,4,3] },
  44: { gong:'坎', name:'雷火丰'  , shi:5, ying:2, liuqin:[1,4,5,2,3,4], gan:[ 6, 6, 6, 7, 7, 7], zhi:[ 4, 2,12, 7, 9,11], wuxing:[1,3,5,2,4,3] },
  40: { gong:'坎', name:'地火明夷', shi:4, ying:1, liuqin:[1,4,5,4,5,3], gan:[ 6, 6, 6,10,10,10], zhi:[ 4, 2,12, 2,12,10], wuxing:[1,3,5,3,5,4] },
  16: { gong:'坎', name:'地水师'  , shi:3, ying:6, liuqin:[1,4,2,4,5,3], gan:[ 5, 5, 5,10,10,10], zhi:[ 3, 5, 7, 2,12,10], wuxing:[1,3,2,3,5,4] },
   9: { gong:'艮', name:'艮为山'  , shi:6, ying:3, liuqin:[5,3,1,5,2,4], gan:[ 3, 3, 3, 3, 3, 3], zhi:[ 5, 7, 9,11, 1, 3], wuxing:[3,2,4,3,5,1] },
  41: { gong:'艮', name:'山火贲'  , shi:1, ying:4, liuqin:[4,5,2,5,2,4], gan:[ 6, 6, 6, 3, 3, 3], zhi:[ 4, 2,12,11, 1, 3], wuxing:[1,3,5,3,5,1] },
  57: { gong:'艮', name:'山天大畜', shi:2, ying:5, liuqin:[2,4,5,5,2,4], gan:[ 1, 1, 1, 3, 3, 3], zhi:[ 5, 1, 3,11, 1, 3], wuxing:[5,1,3,3,5,1] },
  49: { gong:'艮', name:'山泽损'  , shi:3, ying:6, liuqin:[3,4,5,5,2,4], gan:[ 4, 4, 4, 3, 3, 3], zhi:[ 6, 4, 2,11, 1, 3], wuxing:[2,1,3,3,5,1] },
  53: { gong:'艮', name:'火泽睽'  , shi:4, ying:1, liuqin:[3,4,5,1,5,3], gan:[ 4, 4, 4, 6, 6, 6], zhi:[ 6, 4, 2,10, 8, 6], wuxing:[2,1,3,4,3,2] },
  55: { gong:'艮', name:'天泽履'  , shi:5, ying:2, liuqin:[3,4,5,3,1,5], gan:[ 4, 4, 4, 9, 9, 9], zhi:[ 6, 4, 2, 7, 9,11], wuxing:[2,1,3,2,4,3] },
  51: { gong:'艮', name:'风泽中孚', shi:4, ying:1, liuqin:[3,4,5,5,3,4], gan:[ 4, 4, 4, 8, 8, 8], zhi:[ 6, 4, 2, 8, 6, 4], wuxing:[2,1,3,3,2,1] },
  11: { gong:'艮', name:'风山渐'  , shi:3, ying:6, liuqin:[5,3,1,5,3,4], gan:[ 3, 3, 3, 8, 8, 8], zhi:[ 5, 7, 9, 8, 6, 4], wuxing:[3,2,4,3,2,1] },
  36: { gong:'震', name:'震为雷'  , shi:6, ying:3, liuqin:[3,5,2,1,4,2], gan:[ 7, 7, 7, 7, 7, 7], zhi:[ 1, 3, 5, 7, 9,11], wuxing:[5,1,3,2,4,3] },
  4: { gong:'震', name:'雷地豫'  , shi:1, ying:4, liuqin:[2,1,5,1,4,2], gan:[ 2, 2, 2, 7, 7, 7], zhi:[ 8, 6, 4, 7, 9,11], wuxing:[3,2,1,2,4,3] },
  20: { gong:'震', name:'雷水解'  , shi:2, ying:5, liuqin:[5,2,1,1,4,2], gan:[ 5, 5, 5, 7, 7, 7], zhi:[ 3, 5, 7, 7, 9,11], wuxing:[1,3,2,2,4,3] },
  28: { gong:'震', name:'雷风恒'  , shi:3, ying:6, liuqin:[2,3,4,1,4,2], gan:[ 4, 4, 4, 7, 7, 7], zhi:[ 2,12,10, 7, 9,11], wuxing:[3,5,4,2,4,3] },
  24: { gong:'震', name:'地风升'  , shi:4, ying:1, liuqin:[2,3,4,2,3,4], gan:[ 4, 4, 4,10,10,10], zhi:[ 2,12,10, 2,12,10], wuxing:[3,5,4,3,5,4] },
  26: { gong:'震', name:'水风井'  , shi:5, ying:2, liuqin:[2,3,4,4,2,3], gan:[ 4, 4, 4, 5, 5, 5], zhi:[ 2,12,10, 9,11, 1], wuxing:[3,5,4,4,3,5] },
  30: { gong:'震', name:'泽风大过', shi:4, ying:1, liuqin:[2,3,4,3,4,2], gan:[ 8, 8, 8, 4, 4, 4], zhi:[ 2,12,10,12,10, 8], wuxing:[3,5,4,5,4,3] },
  38: { gong:'震', name:'泽雷随'  , shi:3, ying:6, liuqin:[3,5,2,3,4,2], gan:[ 7, 7, 7, 4, 4, 4], zhi:[ 1, 3, 5,12,10, 8], wuxing:[5,1,3,5,4,3] },
  27: { gong:'巽', name:'巽为风'  , shi:6, ying:3, liuqin:[2,3,4,2,1,5], gan:[ 8, 8, 8, 8, 8, 8], zhi:[ 2,12,10, 8, 6, 4], wuxing:[3,5,4,3,2,1] },
  59: { gong:'巽', name:'风天小畜', shi:1, ying:4, liuqin:[3,5,2,2,1,5], gan:[ 1, 1, 1, 8, 8, 8], zhi:[ 1, 3, 5, 8, 6, 4], wuxing:[5,1,3,3,2,1] },
  43: { gong:'巽', name:'风火家人', shi:2, ying:5, liuqin:[5,2,3,2,1,5], gan:[ 6, 6, 6, 8, 8, 8], zhi:[ 4, 2,12, 8, 6, 4], wuxing:[1,3,5,3,2,1] },
  35: { gong:'巽', name:'风雷益'  , shi:3, ying:6, liuqin:[3,5,2,2,1,5], gan:[ 7, 7, 7, 8, 8, 8], zhi:[ 1, 3, 5, 8, 6, 4], wuxing:[5,1,3,3,2,1] },
  39: { gong:'巽', name:'天雷无妄', shi:4, ying:1, liuqin:[3,5,2,1,4,2], gan:[ 7, 7, 7, 9, 9, 9], zhi:[ 1, 3, 5, 7, 9,11], wuxing:[5,1,3,2,4,3] },
  37: { gong:'巽', name:'火雷噬嗑', shi:5, ying:2, liuqin:[3,5,2,4,2,1], gan:[ 7, 7, 7, 6, 6, 6], zhi:[ 1, 3, 5,10, 8, 6], wuxing:[5,1,3,4,3,2] },
  33: { gong:'巽', name:'山雷颐'  , shi:4, ying:1, liuqin:[3,5,2,2,3,5], gan:[ 7, 7, 7, 3, 3, 3], zhi:[ 1, 3, 5,11, 1, 3], wuxing:[5,1,3,3,5,1] },
  25: { gong:'巽', name:'山风蛊'  , shi:3, ying:6, liuqin:[2,3,4,2,3,5], gan:[ 8, 8, 8, 3, 3, 3], zhi:[ 2,12,10,11, 1, 3], wuxing:[3,5,4,3,5,1] },
  45: { gong:'离', name:'离为火'  , shi:6, ying:3, liuqin:[3,1,4,2,1,5], gan:[ 6, 6, 6, 6, 6, 6], zhi:[ 4, 2,12,10, 8, 6], wuxing:[1,3,5,4,3,2] },
  13: { gong:'离', name:'火山旅'  , shi:1, ying:4, liuqin:[1,5,2,2,1,5], gan:[ 3, 3, 3, 6, 6, 6], zhi:[ 5, 7, 9,10, 8, 6], wuxing:[3,2,4,4,3,2] },
  29: { gong:'离', name:'火风鼎'  , shi:2, ying:5, liuqin:[1,4,2,2,1,5], gan:[ 8, 8, 8, 6, 6, 6], zhi:[ 2,12,10,10, 8, 6], wuxing:[3,5,4,4,3,2] },
  21: { gong:'离', name:'火水未济', shi:3, ying:6, liuqin:[3,1,5,2,1,5], gan:[ 5, 5, 5, 6, 6, 6], zhi:[ 3, 5, 7,10, 8, 6], wuxing:[1,3,2,4,3,2] },
  17: { gong:'离', name:'山水蒙'  , shi:4, ying:1, liuqin:[3,1,5,1,4,3], gan:[ 5, 5, 5, 3, 3, 3], zhi:[ 3, 5, 7,11, 1, 3], wuxing:[1,3,2,3,5,1] },
  19: { gong:'离', name:'风水涣'  , shi:5, ying:2, liuqin:[3,1,5,1,5,3], gan:[ 5, 5, 5, 8, 8, 8], zhi:[ 3, 5, 7, 8, 6, 4], wuxing:[1,3,2,3,2,1] },
  23: { gong:'离', name:'天水讼'  , shi:4, ying:1, liuqin:[3,1,5,5,2,1], gan:[ 5, 5, 5, 9, 9, 9], zhi:[ 3, 5, 7, 7, 9,11], wuxing:[1,3,2,2,4,3] },
  47: { gong:'离', name:'天火同人', shi:3, ying:6, liuqin:[3,1,4,5,2,1], gan:[ 6, 6, 6, 9, 9, 9], zhi:[ 4, 2,12, 7, 9,11], wuxing:[1,3,5,2,4,3] },
  0: { gong:'坤', name:'坤为地'  , shi:6, ying:3, liuqin:[5,3,4,5,2,1], gan:[ 2, 2, 2,10,10,10], zhi:[ 8, 6, 4, 2,12,10], wuxing:[3,2,1,3,5,4] },
  32: { gong:'坤', name:'地雷复'  , shi:1, ying:4, liuqin:[2,4,5,5,2,1], gan:[ 7, 7, 7,10,10,10], zhi:[ 1, 3, 5, 2,12,10], wuxing:[5,1,3,3,5,4] },
  48: { gong:'坤', name:'地泽临'  , shi:2, ying:5, liuqin:[3,4,5,5,2,1], gan:[ 4, 4, 4,10,10,10], zhi:[ 6, 4, 2, 2,12,10], wuxing:[2,1,3,3,5,4] },
  56: { gong:'坤', name:'地天泰'  , shi:3, ying:6, liuqin:[2,4,5,5,2,1], gan:[ 1, 1, 1,10,10,10], zhi:[ 1, 3, 5, 2,12,10], wuxing:[5,1,3,3,5,4] },
  60: { gong:'坤', name:'雷天大壮', shi:4, ying:1, liuqin:[2,4,5,3,1,5], gan:[ 1, 1, 1, 7, 7, 7], zhi:[ 1, 3, 5, 7, 9,11], wuxing:[5,1,3,2,4,3] },
  62: { gong:'坤', name:'泽天夬'  , shi:5, ying:2, liuqin:[2,4,5,2,1,5], gan:[ 1, 1, 1, 4, 4, 4], zhi:[ 1, 3, 5,12,10, 8], wuxing:[5,1,3,5,4,3] },
  58: { gong:'坤', name:'水天需'  , shi:4, ying:1, liuqin:[2,4,5,1,5,2], gan:[ 1, 1, 1, 5, 5, 5], zhi:[ 1, 3, 5, 9,11, 1], wuxing:[5,1,3,4,3,5] },
  2: { gong:'坤', name:'水地比'  , shi:3, ying:6, liuqin:[5,3,4,1,5,2], gan:[ 2, 2, 2, 5, 5, 5], zhi:[ 8, 6, 4, 9,11, 1], wuxing:[3,2,1,4,3,5] },
  54: { gong:'兑', name:'兑为泽'  , shi:6, ying:3, liuqin:[4,2,3,1,5,3], gan:[ 4, 4, 4, 4, 4, 4], zhi:[ 6, 4, 2,12,10, 8], wuxing:[2,1,3,5,4,3] },
  22: { gong:'兑', name:'泽水困'  , shi:1, ying:4, liuqin:[2,3,4,1,5,3], gan:[ 5, 5, 5, 4, 4, 4], zhi:[ 3, 5, 7,12,10, 8], wuxing:[1,3,2,5,4,3] },
  6: { gong:'兑', name:'泽地萃'  , shi:2, ying:5, liuqin:[3,4,2,1,5,3], gan:[ 2, 2, 2, 4, 4, 4], zhi:[ 8, 6, 4,12,10, 8], wuxing:[3,2,1,5,4,3] },
  14: { gong:'兑', name:'泽山咸'  , shi:3, ying:6, liuqin:[3,4,5,1,5,3], gan:[ 3, 3, 3, 4, 4, 4], zhi:[ 5, 7, 9,12,10, 8], wuxing:[3,2,4,5,4,3] },
  10: { gong:'兑', name:'水山蹇'  , shi:4, ying:1, liuqin:[3,4,5,5,3,1], gan:[ 3, 3, 3, 5, 5, 5], zhi:[ 5, 7, 9, 9,11, 1], wuxing:[3,2,4,4,3,5] },
  8: { gong:'兑', name:'地山谦'  , shi:5, ying:2, liuqin:[3,4,5,3,1,5], gan:[ 3, 3, 3,10,10,10], zhi:[ 5, 7, 9, 2,12,10], wuxing:[3,2,4,3,5,4] },
  12: { gong:'兑', name:'雷山小过', shi:4, ying:1, liuqin:[3,4,5,4,5,3], gan:[ 3, 3, 3, 7, 7, 7], zhi:[ 5, 7, 9, 7, 9,11], wuxing:[3,2,4,2,4,3] },
  52: { gong:'兑', name:'雷泽归妹', shi:3, ying:6, liuqin:[4,2,3,4,5,3], gan:[ 4, 4, 4, 7, 7, 7], zhi:[ 6, 4, 2, 7, 9,11], wuxing:[2,1,3,2,4,3] },
};
export default {
  name: 'Yaogua',
  data() {
    return {
      brand: '欢迎来到六爻预测',
      guaMethod: '',
      guaType: '9',
      guaData: {},
      timenow: '',
      datenow: '',
      lunarDateNow: '',
      ganzhiNow: '',
      shenShaNow: '',
      res: [],
      benGua: '',
      bianGua: '',
      benGuaOrder: '',
      bianGuaOrder: '',
      benGuaGong: '',
      bianGuaGong: '',
      liuShen: '',
      benShi: '',
      bianShi: '',
      benYing: '',
      bianYing: '',
      benLiuQin: '',
      bianLiuQin: '',
      benGan: '',
      bianGan:'',
      benZhi: '',
      bianZhi: '',
      benWuXing: '',
      bianWuXing: '',
      isDisabled: false,
      config: {
        enableTime: true,
        //wrap: true,
        //altFormat: 'Y-m-d H:m',
        //dateFormat: 'Y年m月d日H时m分',
        locale: Chinese,
        defaultDate: 'today',
      },  
      events: ['onClose', 'onChange', 'onOpen'],
    }
  },
  methods: {
    init(){
      this.res=[];
      this.liuShen = [];
      this.benGuaGong = '';
      this.bianGuaGong = '';
      this.benGua = [];
      this.bianGua = [];
      this.benLiuQin = [],
      this.bianLiuQin = [],
      this.liuShen = [];
      this.isDisabled = false;
    },
    getGua( T ){
      this.timenow = !T ? new Date() : new Date(T); 
      this.datenow = this.chineseDate(this.timenow);
      this.ganzhiNow= this.chineseGanZhiDate(this.timenow);
      this.lunarDateNow = this.chineseLunarDate(this.timenow);
      this.shenShaNow = this.shenSha(this.timenow);
      if (this.guaMethod == '1'){
        var seed=this.timenow.getTime();
        this.res.unshift( this.getThow(seed) );
      }else if( this.guaMethod == '2' ){
        this.init();
        var D = this.timenow;
        var dateArr = {'y': D.getFullYear(), 'm': D.getMonth()+1, 'd': D.getDate(), 'h': D.getHours(), 'f': D.getMinutes()};
        dateArr = Object.assign( ...Object.entries(dateArr).map( ([k,v]) => ({[k]:parseInt(v)} ) ) );
        var nianYueRiShi = dateArr['y'] + dateArr['m'] + dateArr['d'] + dateArr['h'];
        var shangGuaNum = nianYueRiShi % 8;
        var nianYueRiShiFen = nianYueRiShi+ dateArr['f'];
        var xiaGuaNum = nianYueRiShiFen % 8; 
        var xiaGua = '';
        var shangGua = '';
        if ( xiaGuaNum == 0 ){
          xiaGua = xianTianBaGua[ 8 ];
        }else{
          xiaGua = xianTianBaGua[ xiaGuaNum ];
        }
        if (shangGuaNum == 0 ){
          shangGua = xianTianBaGua[ 8 ];
        }else{
          shangGua = xianTianBaGua[ shangGuaNum ];
        }
        var benGuaStr = (xiaGua+shangGua).replace(/0/g,'"').replace(/1/g, "'");
        var bianYaoNum = nianYueRiShiFen % 6;
        if( bianYaoNum == 0){
          bianYaoNum = 6;
        }
        var benGuaArr = benGuaStr.split("");
        if( benGuaArr[ bianYaoNum -1 ] == '"' ){
          benGuaArr[ bianYaoNum -1 ] = 'x';
        }else{
          benGuaArr[ bianYaoNum -1 ] = 'o';
        }
        this.res= benGuaArr.reverse();
      }else{
        this.init();
        D = this.timenow;
        var LD = solarLunar.solar2lunar(D.getFullYear(), D.getMonth()+1, D.getDate() );
        dateArr = {'y': LD.lYear, 'm': LD.lMonth, 'd': LD.lDay,  'h': D.getHours(), 'f': D.getMinutes()};
        for( var key in diZhi ){
          if( diZhi[key] == LD.gzYear[1] ){
            var nianZhiOrder = parseInt(key,10);
            break;
          }
        }
        var shiZhiOrder = Math.floor((1+D.getHours())/2)+1; 
        dateArr = Object.assign( ...Object.entries(dateArr).map( ([k,v]) => ({[k]:parseInt(v)} ) ) );
        shangGuaNum = ( nianZhiOrder + dateArr['m'] + dateArr['d'] )%8;
        xiaGuaNum = (shangGuaNum + shiZhiOrder )%8; 
        if ( xiaGuaNum == 0 ){
          xiaGua = xianTianBaGua[ 8 ];
        }else{
          xiaGua = xianTianBaGua[ xiaGuaNum ];
        }
        if (shangGuaNum == 0 ){
          shangGua = xianTianBaGua[ 8 ];
        }else{
          shangGua = xianTianBaGua[ shangGuaNum ];
        }
        benGuaStr = (xiaGua+shangGua).replace(/0/g,'"').replace(/1/g, "'");
        bianYaoNum = (shangGuaNum + shiZhiOrder) % 6;
        if( bianYaoNum == 0){
          bianYaoNum = 6;
        }
        benGuaArr = benGuaStr.split("");
        if( benGuaArr[ bianYaoNum -1 ] == '"' ){
          benGuaArr[ bianYaoNum -1 ] = 'x';
        }else{
          benGuaArr[ bianYaoNum -1 ] = 'o';
        }
        //this.res = [nianZhiOrder, dateArr.m, dateArr.d, shiZhiOrder];
        this.res=benGuaArr.reverse();
      }
      if(this.res.length == 6){
        this.isDisabled = true;
        this.benGuaOrder = this.guaXiang2Dec(this.res); 
        this.bianGuaOrder = this.guaXiang2Dec(this.res, 1); 
        this.benGua = liuShiSiGua[ this.benGuaOrder ];
        this.benGuaGong = this.benGua['gong']+'宫:';
        this.bianGua= liuShiSiGua[ this.bianGuaOrder ];
        this.bianGuaGong = this.bianGua['gong']+'宫:';
        this.benLiuQin = this.benGua['liuqin'].map( i=>liuQin[i] ).reverse();
        this.bianLiuQin = this.bianGua['liuqin'].map( i=>liuQin[i] ).reverse();
        this.benGan = this.benGua['gan'].map( i=> tianGan[i]).reverse();
        this.bianGan = this.bianGua['gan'].map( i=> tianGan[i]).reverse();
        this.benZhi = this.benGua['zhi'].map( i=> diZhi[i]).reverse();
        this.bianZhi = this.bianGua['zhi'].map( i=> diZhi[i]).reverse();
        this.benWuXing = this.benGua['wuxing'].map( i=> wuXing[i]).reverse();
        this.bianWuXing = this.bianGua['wuxing'].map( i=> wuXing[i]).reverse();
        this.benShi = this.benGua['shi'];
        this.bianShi = this.bianGua['shi'];
        this.benYing = this.benGua['ying'];
        this.bianYing = this.bianGua['ying'];
        this.liuShen = this.liuShenFun( this.timenow );
        let guan = this.benGua['liuqin'].map( (e, i)=> e == 4 ? i+1 : '' ).filter(String);
        let shi = this.benGua['shi'];
        //let ying = this.benGua['ying'];
        //let dong = this.res.map( ( e, i ) => e == 'x' || e == 'o' ? (6-i) : '').filter(String);
        this.guaData = {
          'guanEqShi': guan.includes( shi ) || 1
        };
        
      }else if( this.res.length >6 ){
        this.init();
      }
    },
    guaXiang2Dec( guaStr, flag=false ){
      //flag:true=bian gua, flag=false=ben gua
      guaStr = guaStr.toString().split('').reverse().join('');
      if (flag){
        guaStr = guaStr.replace(/x|'/g, 1).replace(/o|"/g, 0);
      }else{
        guaStr = guaStr.replace(/o|'/g, 1).replace(/x|"/g, 0);
      }
      guaStr = guaStr.replace(/,/g, '');
      return parseInt(guaStr,2);
    },
    chineseDate( D ) {
      var month = D.getMonth()+1;
      return D.getFullYear()+"年"+month+"月"+D.getDate()+"日"+D.getHours()+"时"+D.getMinutes()+"分";
    },
    chineseLunarDate ( D ) {
      var LD = solarLunar.solar2lunar(D.getFullYear(), D.getMonth()+1, D.getDate() );
      var shiZhiOrder = Math.floor((1+D.getHours())/2)+1; 
      var shiZhi = diZhi[ shiZhiOrder ];
      return LD.gzYear+"年"+LD.monthCn+LD.dayCn+"日"+shiZhi+"时";
    },
    chineseGanZhiDate ( D ) {
      var LD = solarLunar.solar2lunar(D.getFullYear(), D.getMonth()+1, D.getDate() );
      var riGan = LD.gzDay[0];
      var riGanOrder = 0;
      if ( riGan == '甲' || riGan == '己' ){
        riGanOrder = 1;
      }else if ( riGan == '乙' || riGan == '庚' ){
        riGanOrder = 3;
      }else if( riGan == '丙' || riGan == '辛' ){
        riGanOrder = 5;
      }else if( riGan == '丁' || riGan == '壬' ){
        riGanOrder = 7;
      }else if( riGan == '戊' || riGan == '癸' ){
        riGanOrder = 9;
      }
      var shiZhiOrder = Math.floor((1+D.getHours())/2)+1; 
      var shiGanOrder = (shiZhiOrder -1 + riGanOrder) % 10;
      if( shiGanOrder == 0 )
        shiGanOrder = 10;
      var shiGanZhi =  tianGan[ shiGanOrder ]  + diZhi[ shiZhiOrder ];
      return LD.gzYear+"年 "+LD.gzMonth+"月 "+LD.gzDay+"日 "+shiGanZhi+"时";
    },
    liuShenFun( D ) {
      var LD = solarLunar.solar2lunar(D.getFullYear(), D.getMonth()+1, D.getDate() );
      var riGan = LD.gzDay[0];
      var riGanOrder;
      var key;
      var liuShenArr =[];
      for ( key in tianGan){
        if( tianGan[key] == riGan )
          riGanOrder = Number(key);
      }
      if( riGanOrder == 1 | riGanOrder == 2)
        liuShenArr = [1,6,5,4,3,2];
      else if( riGanOrder == 3 | riGanOrder == 4)
        liuShenArr = [2,1,6,5,4,3];
      else if( riGanOrder == 5 )
        liuShenArr = [3,2,1,6,5,4];
      else if( riGanOrder == 6 )
        liuShenArr = [4,3,2,1,6,5];
      else if( riGanOrder == 7 | riGanOrder == 8)
        liuShenArr = [5,4,3,2,1,6];
      else if( riGanOrder == 9 | riGanOrder == 10)
        liuShenArr = [6,5,4,3,2,1];
      return liuShenArr.map( i=> liuShenDic[i] );
    },
    shenSha( D ) {
      var LD = solarLunar.solar2lunar(D.getFullYear(), D.getMonth()+1, D.getDate() );
      var riGan = LD.gzDay[0];
      var riZhi = LD.gzDay[1];
      var riGanOrder = 0;
      var riZhiOrder = 0;
      var key;
      for ( key in tianGan){
        if( tianGan[key] == riGan )
          riGanOrder = Number(key);
      }
      for ( key in diZhi){
        if( diZhi[key] == riZhi )
          riZhiOrder = Number(key);
      }
      var taiYiGuiRen = '';
      var luShen = '';
      var yiMa = '';
      var taoHua= '';

      if ( [1,5,7].includes(riGanOrder))
        taiYiGuiRen = diZhi[2]+', '+diZhi[8];
      else if( [2,6].includes(riGanOrder))
        taiYiGuiRen = diZhi[1]+', '+diZhi[9];
      else if( [3,4].includes(riGanOrder))
        taiYiGuiRen = diZhi[12]+', '+diZhi[10];
      else if( [9,10].includes(riGanOrder))
        taiYiGuiRen = diZhi[4]+', '+diZhi[6];
      else if( riGanOrder == 8 )
        taiYiGuiRen = diZhi[7]+', '+diZhi[3];

      var luShenArr = { 1:3, 2:4, 3:6, 4:7, 5:6, 6:7, 7:9, 8:10, 9:12, 10:1}
      luShen = diZhi[ luShenArr[ riGanOrder ] ];
      var yiMaArr = { 1:3, 9:3, 5:3, 6:12, 10:12, 2:12, 3:9, 7:9, 11:9, 12:6, 4:6, 8:6};
      yiMa = diZhi[ yiMaArr[ riZhiOrder ] ];
      var taoHuaArr = {3:4, 7:4, 11:4, 9:10, 1:10, 5:10, 12:1, 4:1, 8:1, 6:7, 10:7, 2:7};
      taoHua = diZhi[ taoHuaArr[ riZhiOrder ] ];
      return '太乙贵人: '+taiYiGuiRen+'    禄神: '+luShen+'    驿马:'+yiMa+'    桃花:'+taoHua;
    },
    countThow( arrayThow ) {
      var count = 0;
      var res=['o', '"', "'", "x"];
      for (var i=0; i< arrayThow.length; ++i ) {
        //>0.5=字, <=0.5=背
        if ( arrayThow[i] > 0.5 )
          count++;
      }
      if( count == 0 ) 
        return res[0];
      if( count == 1 )
        return res[1];
      if( count == 2 )
        return res[2];
      if( count == 3 )
        return res[3];
    },
    getThow( seeds ) {
      var results = [gen.create(seeds).random(), gen.create().random(), gen.create().random()];
      return this.countThow(results);
    },
  },
  components: {
    flatPickr,
    jieGua
  }
}
</script>
<style scoped>
@import "../../node_modules/flatpickr/dist/flatpickr.css";
h3 {
  margin: 40px 0 0;
}
.show ul {
  list-style-type: none;
  padding: 0;
}
.show li {
  display: inline-block;
  margin: 0 10px;
  padding-bottom: 0;
  line-height:.8em;
}
a {
  color: #42b983;
}
.show{
  width: 4em;
}
.yin, .yang {
  width: 4em;
  height: .3em;
  display: inline-block;
  text-align: right;
  margin-bottom:2px;
}
.yin{
  background: linear-gradient(to right, #000 0%, #000 33%, #fff 33%, #fff 66%, #000 66%, #000 100%);
}
.yang{
  background: black;
}
.datenow{
  display:inline-block;
  width: 10em;
}
#gen th,td{
  text-align:justify;
  white-space: pre;
}
.tabguaxiang td,.tabguaxiang th {
  text-align:center;
  min-width:9em;
}
.disabled{
  display:none;
}
.guainfo{
  font-size:8px;
  float:left;
}
.shiying{
  font-size:8px;
}
.zhanshi{
  width: 6em;
}
</style>
