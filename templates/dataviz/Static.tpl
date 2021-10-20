{crmAPI var='case' entity='Case' action='getsingle' sequential=0 return="contact_id,subject,start_date" id=$id}
<div class="row">
  <div class="col-3">
    <h3>{$case.subject} <i>#{$id}</i></h3>
  </div>
  <div class="col-3">{$case.start_date}</div>
</div>
