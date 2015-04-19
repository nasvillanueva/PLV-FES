<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <title>Evaluation Results</title>
    <style  type="text/css">
        @page {
            size: 215.9mm 330.2mm;
            @top-center { content: element(header); }
        }
        .top-wrapper{
            page-break-after: always;
            width:100%;
        }

        .plv-header{
            width:550px;
            margin:0 auto;
        }

        .plv-header #plvlogo{
            height:0.89in;
            width:0.89in;

        }
        .plvlogowrapper,.plvdesc{
            float:left;
        }
        .plvdesc{
            margin-top:25px;
            margin-left:10px;
        }
        .plv-header #plvname{
            margin:0;
        }
        .plv-header hr{
            margin:0;
            width:428px;
            border:1px solid black;
        }
        .plv-header p{
            text-align: left;
            font-style: italic;
            margin:0;
        }

        .header{
            text-align:center;
            margin-bottom:0;
        }
        .office,.label{
            margin-top:0;
            margin-bottom:0;
        }
        .college{
            margin-top:1px;
            margin-bottom:8px;
            font-style:italic;
        }
        .label{
            text-transform: uppercase;
            text-decoration: underline;
        }
        .label2, .rating{
            text-transform: uppercase;
        }
        .rating{
            margin-top:0;
            text-align: right;
            font-size:1.1em;
        }
        .syay{
            margin-top:0;
            margin-bottom:5px;
            font-style:italic;
        }

        .name, .overall{
            font-weight: bold;
        }
        .overall{
            text-transform: uppercase;
        }

        .nameoverall{
            padding: 0 30px 0 30px;
        }

        .nameoverall p{
            margin-top:0;
            margin-bottom:0;
            font-size:1.3em;
        }
        .score{
            font-weight: bold;
        }
        .description{
            margin-top:10px;
            width:100%;
        }

        .description table{
            width:600px;
            display:inline-table;
            margin-left:50px;
            border-spacing: 0 50px;
        }

        td.score{
            width:30%;
            text-indent: 70px;
        }
        td.scoredesc{
            text-indent: 30px;
        }
        .resultwrapper{
            margin-top:15px;
            padding: 0 30px 0 30px;
        }
        .result {
            width:48.5%;
            float:left;
        }
        .commentwrapper{
            float:right;
            width:48.5%;
        }
        .category,.item{
            font-size:.92em;
            text-align: justify;
        }
        .category .label2{
            text-align:center;
            margin-top:5px;
            margin-bottom:0;
        }
        .category ol{
            list-style-position: inside;
            margin-top:0;
            margin-bottom:0;
            padding-left:10px;
            padding-right:10px;
        }
        .commentwrapper .label{
            margin-bottom:5px;
        }
        .comments ul{
            list-style-position: inside;
            margin-top:0;
            margin-bottom:0;
            padding-left:10px;
            padding-right:10px;
        }
        .comments li{
            list-style-type: square;
            text-align: justify;
            font-size:1em;
            margin-bottom: 10px;
        }
        .italic{
            font-style: italic;
        }

        /*div{*/
            /*border:1px solid black;*/
        /*}*/

    </style>
</head>
<body>
<g:each in="${evaluation}" var="e">
<div class="top-wrapper">
    <div class="header">
        <div class="plv-header">
            <div class="plvlogowrapper">
                <rendering:inlineJpeg bytes="${plvlogo}" id="plvlogo"/>
            </div>
            <div class="plvdesc">
                <h3 id="plvname">PAMANTASAN NG LUNGSOD NG VALENZUELA</h3>
                <hr/>
                <p>Poblacion II, Malinta, Valenzuela City</p>
            </div>
            <div style="clear:both"></div>
        </div>
        <h3 class="office">OFFICE OF THE DEAN</h3>
        <h3 class="college">${e?.prof?.college?.collegeName?:'College not set.'}</h3>
        <h4 class="label">Students' Evaluation</h4>
        <p class="syay">${semester}<sup>${(semester == 1)?'st':'nd'}</sup> Semester, S.Y ${schoolYear} - ${schoolYear + 1}</p>
    </div>
    <div class="nameoverall">
        <p><span class="italic">Name of Faculty:</span> <span class="name">${(e?.prof?.salutation?:'')  + ' ' + e.prof.toString()}</span></p>
        <p><span class="italic">Overall Rating:</span> <span class="overall"><g:formatNumber number="${new java.text.DecimalFormat('0.00').format(e.overall)}" type="number" maxFractionDigits="2" minFractionDigits="2" /></span></p>
    </div>
    <div class="description">
        <table>
            <tr>
                <th class="label italic" colspan="2">Description:</th>
            </tr>
            <g:each in="${interpretation}" var="k">
            <tr>
                <td class="score">${k.scale} - ${k.rating}</td>
                <td class="scoredesc">${k.description}</td>
            </tr>
            </g:each>
        </table>
    </div>
    <div class="resultwrapper">
        <div class="result">
            <h4 class="label italic">CRITERIA:</h4>
            <g:each in="${category}" var="cat">
                <div class="category">
                    <h5 class="label2">${cat.catIndex + '. ' + cat.description}</h5>
                    <ol>
                    <g:each in="${question}" var="q">
                        <g:if test="${q.evaluationCategory.equals(cat)}">
                            <li class="item">${q.question}</li>
                        </g:if>
                    </g:each>
                    </ol>
                    <g:each in="${e.score}" var="score">
                        <g:if test="${score.category.id == cat.id}">
                            <h4 class="rating">RATING: <g:formatNumber number="${new java.text.DecimalFormat('#.##').format(score.score)}" type="number" maxFractionDigits="2" minFractionDigits="2" /></h4>
                        </g:if>
                    </g:each>
                </div>
            </g:each>
        </div>
        <div class="commentwrapper">
            <h4 class="label italic">COMMENTS / SUGGESTIONS:</h4>
            <div class="comments">
                <ul>
                    <g:each in="${comments}" var="c">
                        <g:if test="${c.prof.equals(e.prof)}">
                            <li>${c.comment.split('[\\.?!]')*.toLowerCase()*.capitalize().join('.').split('[\\n]')*.toLowerCase()*.capitalize()*.trim().join('. ')}</li>
                        </g:if>
                    </g:each>
                </ul>
            </div>
        </div>
        <div style="clear:both;"></div>
    </div>
</div>
</g:each>
</body>
</html>